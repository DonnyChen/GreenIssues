from django.shortcuts import render_to_response,redirect, get_object_or_404
from django.http import HttpResponse
from django.core.paginator import Paginator, InvalidPage, EmptyPage, PageNotAnInteger
import subprocess
from apps.bluefish.models import BranchInfo, ChangeInfo
from utility import fetchdata


# Get branch information by default
def get_branchinfo(request):
    latest_change_list = mypaginator(request, BranchInfo.objects.all().order_by('-id'))

    return render_to_response("bluefish/list.html", locals())

# Get branch information by default
def remove_branchinfo(request, branch_id):
    branch = get_object_or_404(BranchInfo, pk=branch_id)
    branch.delete()

    return  redirect("/bluefish/")


# Get changes information by using branch id
def get_changeinfo(request, branch_id):
    branch = get_object_or_404(BranchInfo, pk=branch_id)
    search_key = request.POST.get('searchkey', None)
    if search_key is None:
        search_key = request.session.get('search_key', None)

    if search_key is not None:
        request.session['search_key'] = search_key
        changes = mypaginator(request, ChangeInfo.objects.filter(
            branch__id=branch_id,
            file_name__icontains=search_key))
    else:
        changes = mypaginator(request, branch.changeinfo_set.all())

    return render_to_response("bluefish/detail.html", locals())

# Generate changelist by using brach, current build, baseline build
def generate_changelist(request):
    # get value of branch, build
    branch = request.GET.get('branch', None)
    baseline_build = request.GET.get('basebuild', None)
    current_build = request.GET.get('currentbuild', None)
    layer = request.GET.get('layer', 'SYP')
    # call sync cmd
    if(current_build is not None ) and (baseline_build is not None):
        startupinfo = subprocess.STARTUPINFO()
        startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW
        change_process = subprocess.Popen([r"F:\GreenIssues\greenissues\utility\syncbuild.cmd", \
        branch, baseline_build, current_build, layer], stdout=subprocess.PIPE, startupinfo=startupinfo,shell=True)
        exitcode = change_process.wait()
        # call fetch data
        data_path = 'F:\\'+branch+'-'+baseline_build+'-'+current_build+'\\now'
        fetchdata.getChange(data_path)
    # redirect to changelist page
    return  redirect("/bluefish/")

def mypaginator(request, paginator_data):
    paginator = Paginator(paginator_data, 30)
    try:
        page = int(request.GET.get('page', 1))
        paginator_data = paginator.page(page)
    except (EmptyPage, InvalidPage, PageNotAnInteger):
        paginator_data = paginator.page(1)

    return paginator_data