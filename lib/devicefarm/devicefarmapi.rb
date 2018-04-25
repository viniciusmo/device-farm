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
		p upload_result
		while(upload_result.status != "SUCCEEDED")
			upload_result = get_upload_result(upload)
			p upload_result
			sleep(POLLING_INTERVAL)
		end
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

	def random_name_for_test
		(0...8).map { (65 + rand(26)).chr }.join
	end

	def run(project:,device_pool:,upload_app:,upload_artifact_test:,type:)
		@client.schedule_run({
		  project_arn: project.arn, 
		  app_arn: upload_app.arn,
		  device_pool_arn: device_pool.arn, 
		  name: random_name_for_test,
		  test: { 
		    type: type,
		    test_package_arn: upload_artifact_test.arn
		  }
		})
	end

end