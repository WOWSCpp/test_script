import os
import sys
import time

class AutoRun(object):
	def __init__(self):
		self.warmup 		= True
		self.now_percent	= 19
		self.max_percent	= 19
		self.task_count 	= 0
		self.warmup_time 	= 1800
		self.stable_time 	= 10800
		self.numjobs		= 4.0

	def wait_and_check(self, t, status):
		time.sleep(t)
		#assert(status == 0)

	def reset_bcache(self):
		print ("reset bcache start !!!!!!!!!!!!!!!!!!!!!!")
		status = os.system('sh /root/test_script/release.sh')
		print (status)
		self.wait_and_check(5, status)
		
		status = os.system('sh /root/test_script/bcache.sh')
		self.wait_and_check(5, status)
		print ("reset bcache done !!!!!!!!!!!!!!!!!!!!!!")

	def change_parameter(self):
		# change random_distribution every two tasks
		# change runtime every one task
		print ("change parameter start !!!!!!!!!!!!!!!!!!!!!!")
		hot 	= self.now_percent
		cold 	= 100 - self.now_percent
		random_distribution = "zoned:100/%s:0/%s" % (hot, cold) 
		#status = os.system("sed -i 's@random_distribution=.*@random_distribution=%s@' ray.fio" % random_distribution)
		#self.wait_and_check(1, status)
		
		if self.warmup:
			runtime = str(self.warmup_time)
		else:
			runtime = str(self.stable_time)
		status = os.system("sed -i 's/runtime=.*/runtime=%s/' mix_ray.fio" % runtime)
		self.wait_and_check(1, status)

		print ("parameter after change: random_distribution: %s, runtime: %s" % (random_distribution, runtime)) 


	def run_task(self):
		print ("run task start !!!!!!!!!!!!!!!!!!!!!!")
		status = os.system('sh /root/test_script/test1.sh')
		self.wait_and_check(1, status)
		print ("run task done !!!!!!!!!!!!!!!!!!!!!!")


	def copy_and_upload_data(self):
		# first cd to the git path

		print ("copy and upload data start !!!!!!!!!!!!!!!!!!!!!!")
		root_dir = "/root/results/auto_test_res/" + str(self.now_percent)
		if self.warmup:
			root_dir += "/warmup/"
		else:
			root_dir += "/stable/"

		print ("Now cd to %s" % root_dir)
		os.chdir(root_dir)
		status = os.system("cd %s" % root_dir)
		self.wait_and_check(1, status)

		# second do the things with git
		_percent   = str(self.now_percent)
		_status = "warmup" if self.warmup else "stable"
		status = os.system('cp /root/test_script/*.log .')
		self.wait_and_check(1, status)
		status = os.system('cp /root/results/*.txt .')
		#self.wait_and_check(1, status)
		#status = os.system('git add *')
		#self.wait_and_check(1, status)
		#status = os.system('git commit -m "%s-%s"' % (_percent, _status))
		#self.wait_and_check(5, status)
		#status = os.system('git push')
		#self.wait_and_check(5, status)

		# last cd to the script path
		os.chdir("/root/test_script/")
		status = os.system("cd /root/test_script/")
		self.wait_and_check(1, status)
		print ("copy and upload from %s done" % root_dir)


	def main_loop(self):
		while self.now_percent <= self.max_percent:
			self.reset_bcache()
			self.change_parameter()
			self.run_task()
			self.copy_and_upload_data()

			self.task_count += 1
			if self.task_count % 2 == 0:
				self.now_percent += 1

			if self.warmup:
				self.warmup = False
			else:
				self.warmup = True
			time.sleep(1800)

if __name__ == '__main__':
	run = AutoRun()
	run.main_loop()
