from django.shortcuts import render, redirect,HttpResponse

import datetime
import hashlib

from cmdb import models

def login(request):
	error_msg = ''
	if request.method == 'POST':
		user = request.POST.get('username', None)
		pwd = request.POST.get('password', None)

		print(user,md5_encode(pwd))
		# 生成session实例
		db_session = models.Session_class()
		data = db_session.query(models.User).filter_by(name=user).filter_by(password=md5_encode(pwd)).first()
		# print(data)
		db_session.close()
		if data:
			return redirect('/index/'+user)
		# if user == 'root' and pwd == '123':
		# 	return redirect('/index')
		else:
			error_msg = '用户名或者密码错误！'
	return render(request, 'login.html', {'error_msg': error_msg})


# HOST_LIST = [
# 	{'id':1,'host': 'web01', 'ip': '172.16.1.8', 'port': '80', 'dns_name': 'web01', 'desc': 'Nginx Web服务器', 'pc': 'HP 730',
# 	 'buyDate': '2017-12-01', 'modify_user': 'admin', 'modify_date': '2017-12-05'},
# 	{'id':2,'host': 'web02', 'ip': '172.16.1.9', 'port': '80', 'dns_name': 'web02', 'desc': 'Nginx Web服务器', 'pc': 'HP 730',
# 	 'buyDate': '2017-12-01', 'modify_user': 'admin', 'modify_date': '2017-12-05'},
# 	{'id':3,'host': 'web03', 'ip': '172.16.1.10', 'port': '80', 'dns_name': 'web03', 'desc': 'Nginx Web服务器', 'pc': 'HP 730',
# 	 'buyDate': '2017-12-01', 'modify_user': 'admin', 'modify_date': '2017-12-05'},
# ]


def index(request,**kwargs):
	# 生成session实例
	user = kwargs['username']
	HOST_LIST=[]
	db_session = models.Session_class()
	data = db_session.query(models.User).filter_by(name=user).first()
	for g in data.hosts_group:
		for h in g.hosts_list:
			if h.status==1:
				HOST_LIST.append(h)
	db_session.close()
	return render(request, 'index.html',{'host_list':HOST_LIST,'username':user})


def host_del(request,**kwargs):
	user = kwargs['username']
	if request.method == 'POST':
		nid = request.POST.get('nid')
		print(nid)
		# 生成session实例
		db_session = models.Session_class()
		hosts = db_session.query(models.Hosts).filter(models.Hosts.id == nid).first()
		hosts.status = 0
		hosts.modify_user =user
		hosts.modify_datetime = datetime.datetime.now()
		db_session.commit()
		db_session.close()
	return redirect('/index/'+user)

def detail(request):

	nid = request.GET.get('nid')
	print(nid)
	# 生成session实例
	db_session = models.Session_class()
	data = db_session.query(models.Hosts).filter(models.Hosts.id == nid).filter(models.Hosts.status==1).first()
	db_session.close()
	return render(request,'detail.html',{'data':data})


def add(request,**kwargs):
	user = kwargs['username']
	if request.method == 'POST':
		inp_hosts_group = request.POST.get('inp_hg')
		# print(inp_hosts_group)
		inp_host = request.POST.get('inp_host')

		inp_ip = request.POST.get('inp_ip')
		inp_port = request.POST.get('inp_port')
		inp_dns_name = request.POST.get('inp_dns_name')
		inp_remark = request.POST.get('inp_remark')
		inp_pc = request.POST.get('inp_pc')
		inp_buy_year = request.POST.get('inp_buy_year')


		h = models.Hosts(host=inp_host,ip=inp_ip,port=inp_port,dns_name=inp_dns_name,
				  remark=inp_remark,pc=inp_pc,buy_year=inp_buy_year,modify_user='admin',
				  modify_datetime=datetime.datetime.now(),status=1,hosts_group_id=inp_hosts_group)

		print(h)
		# 生成session实例
		db_session = models.Session_class()
		db_session.add(h)
		db_session.commit()
		db_session.close()
	return redirect('/index/'+user)


def edit(request,**kwargs):
	user = kwargs['username']
	nid = request.GET.get('nid')
	print(nid)
	# 生成session实例
	db_session = models.Session_class()
	hosts = db_session.query(models.Hosts).filter(models.Hosts.id == nid).filter(models.Hosts.status == 1).first()

	if request.method == 'GET':
		host_group_list = db_session.query(models.Hosts_Group).all()
		db_session.close()
		return render(request, 'edit.html', {'hosts': hosts,'host_group_list':host_group_list,'username':user})

	if request.method == 'POST':
		inp_hosts_group = request.POST.get('inp_hg')
		inp_host = request.POST.get('inp_host')
		inp_ip = request.POST.get('inp_ip')
		inp_port = request.POST.get('inp_port')
		inp_dns_name = request.POST.get('inp_dns_name')
		inp_remark = request.POST.get('inp_remark')
		inp_pc = request.POST.get('inp_pc')
		inp_buy_year = request.POST.get('inp_buy_year')
		hosts.host=inp_host
		hosts.ip=inp_ip
		hosts.port = inp_port
		hosts.dns_name = inp_dns_name
		hosts.remark = inp_remark
		hosts.pc = inp_pc
		hosts.buy_year = inp_buy_year
		hosts.modify_datetime = datetime.datetime.now()
		hosts.hosts_group_id = inp_hosts_group
		print(hosts)
		db_session.commit()

		db_session.close()
		return HttpResponse('update successful..')


def md5_encode(*msg):
	md = hashlib.md5()
	for m in msg:
		md.update(m.encode('utf8'))

	return md.hexdigest()