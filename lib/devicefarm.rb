class DeviceFarm

	def self.test_with_calabash(project_name:,
								device_pool_name:,
								apk_path:,
								calabash_test_package_path:)
        devicefarmapi = DeviceFarm::DeviceFarmApi.new()
        project = devicefarmapi.get_project_by_name(project_name:project_name)
        device_pool = devicefarmapi.get_device_pool_by_name(
    		pool_name:device_pool_name,
    		project:project)
    	upload_apk = devicefarmapi.upload_artifact(
    		file_path:apk_path,
    		type: "ANDROID_APP",
    		project:project)
    	upload_artifact_test = devicefarmapi.upload_artifact(
    		file_path:calabash_test_package_path,
    		type: "CALABASH_TEST_PACKAGE",
    		project:project)
    	devicefarmapi.run(project:project,
    					  device_pool:device_pool,
    					  upload_apk:upload_apk,
    					  upload_artifact_test:upload_artifact_test,
    					  type: "CALABASH")
  	end

end

require "devicefarm/devicefarmapi"