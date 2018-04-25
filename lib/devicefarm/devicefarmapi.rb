require "aws-sdk-devicefarm"

POLLING_INTERVAL = 3  

class DeviceFarm::DeviceFarmApi

	def initialize
		@client = Aws::DeviceFarm::Client.new
	end

	def get_project_by_name(project_name:)
		project = @client.list_projects().projects.select{ |project| project.name == project_name}[0]
	end

	def get_device_pool_by_name(pool_name:,project:)
		device_pool_response =  @client.list_device_pools(type: "PRIVATE", arn: project.arn)
		device_pool = device_pool_response.device_pools.select{ |device_pool| device_pool.name == pool_name}[0]
		device_pool
	end


	 def upload_file(url, path)
	    url = URI.parse(url)
	    contents = File.open(path, 'rb').read
	    Net::HTTP.new(url.host).start do |http|
	          http.send_request("PUT", url.request_uri, contents, { 'content-type' => 'application/octet-stream' })
	    end
	end

	def get_upload_result(upload)
		uploadResult  = @client.get_upload({
		  		arn: "#{upload.arn}",
		}).upload
	end

	def wait_for_upload_finish(upload)
		upload_result = get_upload_result(upload)
		while(!upload_result.status == "SUCCEEDED")
			upload_result = get_upload_result(upload)
			sleep(POLLING_INTERVAL)
		end
		sleep(10)
	end

	def upload_artifact(file_path:,type:,project:)
		file = File.new(file_path)
		upload = @client.create_upload({
  				project_arn: project.arn,
  				name: File.basename(file),
  				type: type}).upload
		upload_file(upload.url,file_path)
		wait_for_upload_finish(upload)
		upload
	end

	def run(project:,device_pool:,upload_apk:,upload_artifact_test:,type:)
		@client.schedule_run({
		  project_arn: project.arn, 
		  app_arn: upload_apk.arn,
		  device_pool_arn: device_pool.arn, 
		  name: "Test 2",
		  test: { 
		    type: type,
		    test_package_arn: upload_artifact_test.arn
		  }
		})
	end

end