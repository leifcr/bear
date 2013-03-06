require 'test_helper'

class BearTest < ActiveSupport::TestCase
  test "Bear creates the build directory" do
    if File.directory?(File.join(Rails.root.to_s, Bear.build_dir))
      FileUtils.rm_rf(File.join(Rails.root.to_s, Bear.build_dir))
    end
    assert_difference("Dir[File.join(Rails.root.to_s, '*')].size", 1) do
      Bear.create_build_dir
    end
  end

  test "Bear's build directory has proper permissions" do
    Bear.create_build_dir
    # Check if the permission is actually 0754
    # acceptiing both 492 and 493 
    # 493 will occure if the test is done through a VirtualBox mounted share.
    perm = File.stat(File.join(Rails.root.to_s, Bear.build_dir)).mode & 0777
    assert((492 == perm) || (493 == perm), "Permission on folder should be 0754 or 0755")
  end
end
