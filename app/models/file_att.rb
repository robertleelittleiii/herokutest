class FileAtt < ActiveRecord::Base
    mount_uploader :file_info, FileUploader

end
