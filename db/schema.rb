# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130128193501) do

  create_table "build_parts", :force => true do |t|
    t.integer  "build_id",                               :null => false
    t.string   "name"
    t.text     "steps"
    t.text     "output",           :limit => 2147483647
    t.string   "status"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.text     "shared_variables"
  end

  create_table "builds", :force => true do |t|
    t.integer  "project_id"
    t.string   "commit"
    t.string   "status"
    t.text     "output"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "build_dir"
    t.datetime "started_at"
    t.datetime "scheduled_at"
    t.string   "author"
    t.string   "email"
    t.datetime "committed_at"
    t.text     "commit_message"
    t.datetime "finished_at"
    t.integer  "build_no"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "queue"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "hooks", :force => true do |t|
    t.integer  "project_id",    :null => false
    t.string   "hook_name",     :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.text     "configuration"
    t.text     "hooks_enabled"
  end

  create_table "projects", :force => true do |t|
    t.string   "name",                               :null => false
    t.string   "vcs_type",                           :null => false
    t.string   "vcs_source",                         :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "max_builds"
    t.string   "hook_name"
    t.integer  "position"
    t.string   "vcs_branch"
    t.integer  "total_builds"
    t.integer  "failed_builds"
    t.string   "fetch_type",    :default => "clone"
    t.string   "output_path",   :default => ""
  end

  create_table "projects_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "project_id"
  end

  add_index "projects_users", ["project_id", "user_id"], :name => "index_projects_users_on_project_id_and_user_id"
  add_index "projects_users", ["user_id", "project_id"], :name => "index_projects_users_on_user_id_and_project_id"

  create_table "shared_variables", :force => true do |t|
    t.integer  "step_list_id"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "step_lists", :force => true do |t|
    t.string   "name"
    t.text     "steps"
    t.integer  "project_id", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
