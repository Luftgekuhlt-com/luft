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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190817161805) do

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       null: false
    t.string   "slug",       null: false
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dealers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                     null: false
    t.string   "address"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "phone"
    t.string   "website",     limit: 1000
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "document_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "document_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id"], name: "index_document_categories_on_category_id", using: :btree
    t.index ["document_id"], name: "index_document_categories_on_document_id", using: :btree
  end

  create_table "document_part_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "document_part_id"
    t.string   "title",              limit: 1000
    t.string   "caption",            limit: 1000
    t.string   "link_url",           limit: 1000
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "crop_actions",       limit: 65535
    t.integer  "display_order"
    t.boolean  "hidden"
    t.boolean  "featured"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.text     "content",            limit: 65535
    t.index ["document_part_id"], name: "index_document_part_images_on_document_part_id", using: :btree
  end

  create_table "document_parts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "document_id"
    t.string   "type"
    t.string   "title",               limit: 1000,                        null: false
    t.text     "content",             limit: 65535
    t.text     "additional_data",     limit: 4294967295
    t.integer  "display_order"
    t.boolean  "hidden"
    t.integer  "created_by"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.string   "pane",                                   default: "main"
    t.integer  "document_section_id",                    default: 0,      null: false
    t.index ["document_id"], name: "index_document_parts_on_document_id", using: :btree
  end

  create_table "document_sections", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "document_id"
    t.string   "layout"
    t.string   "title"
    t.text     "additional_data", limit: 65535
    t.integer  "display_order"
    t.boolean  "hidden"
    t.integer  "created_by"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["document_id"], name: "index_document_sections_on_document_id", using: :btree
  end

  create_table "documents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title",                   limit: 1000,                  null: false
    t.string   "slug",                    limit: 1000,                  null: false
    t.integer  "parent_id"
    t.string   "subtitle",                limit: 1000
    t.string   "main_image_file_name"
    t.string   "main_image_content_type"
    t.integer  "main_image_file_size"
    t.datetime "main_image_updated_at"
    t.text     "css",                     limit: 65535
    t.text     "scripts",                 limit: 65535
    t.text     "meta_data",               limit: 65535
    t.text     "additional_data",         limit: 65535
    t.integer  "order"
    t.boolean  "hidden"
    t.integer  "created_by"
    t.datetime "published_at"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "type"
    t.boolean  "archived"
    t.boolean  "featured",                              default: true
    t.datetime "expires_at"
    t.boolean  "home",                                  default: false
  end

  create_table "home_portals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "category",                                default: "primary", null: false
    t.string   "title",                     limit: 1000,                      null: false
    t.string   "link_url_1",                limit: 1000
    t.string   "link_text_1",               limit: 1000
    t.string   "link_url_2",                limit: 1000
    t.string   "link_text_2",               limit: 1000
    t.string   "main_image_file_name"
    t.string   "main_image_content_type"
    t.integer  "main_image_file_size"
    t.datetime "main_image_updated_at"
    t.string   "mobile_image_file_name"
    t.string   "mobile_image_content_type"
    t.integer  "mobile_image_file_size"
    t.datetime "mobile_image_updated_at"
    t.text     "content",                   limit: 65535
    t.text     "additional_data",           limit: 65535
    t.integer  "display_order"
    t.boolean  "hidden"
    t.integer  "created_by"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  create_table "home_slides", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title",                     limit: 1000,                    null: false
    t.string   "sub_title",                 limit: 1000
    t.string   "video_url",                 limit: 1000
    t.string   "button_link",               limit: 1000
    t.string   "button_text",               limit: 1000
    t.string   "caption",                   limit: 2000
    t.string   "main_image_file_name"
    t.string   "main_image_content_type"
    t.integer  "main_image_file_size"
    t.datetime "main_image_updated_at"
    t.text     "content",                   limit: 65535
    t.text     "additional_data",           limit: 65535
    t.integer  "display_order"
    t.boolean  "hidden"
    t.integer  "created_by"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.string   "mobile_image_file_name"
    t.string   "mobile_image_content_type"
    t.integer  "mobile_image_file_size"
    t.datetime "mobile_image_updated_at"
    t.string   "content_anchor",                          default: "left"
    t.string   "slide_type",                              default: "basic"
  end

  create_table "news_links", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title",                                         null: false
    t.string   "url_link",         limit: 4000
    t.string   "author"
    t.string   "keywords"
    t.date     "publish_date"
    t.boolean  "hidden",                        default: false
    t.boolean  "performance_only",              default: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "performance_histories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title",                                null: false
    t.string   "composer"
    t.integer  "season"
    t.string   "performance_dates"
    t.text     "content",                limit: 65535
    t.date     "first_performance_date"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "press_releases", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title",                                               null: false
    t.text     "content",               limit: 65535
    t.string   "word_doc_file_name"
    t.string   "word_doc_content_type"
    t.integer  "word_doc_file_size"
    t.datetime "word_doc_updated_at"
    t.string   "pdf_doc_file_name"
    t.string   "pdf_doc_content_type"
    t.integer  "pdf_doc_file_size"
    t.datetime "pdf_doc_updated_at"
    t.string   "keywords"
    t.date     "publish_date"
    t.boolean  "hidden",                              default: false
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  create_table "sync_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "additional_info", limit: 65535
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "is_category", default: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "is_admin"
    t.string   "qb_access_token"
    t.string   "qb_access_secret"
    t.string   "qb_company_id"
    t.datetime "qb_token_expires_at"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "video_tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "video_id"
    t.integer  "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_video_tags_on_tag_id", using: :btree
    t.index ["video_id"], name: "index_video_tags_on_video_id", using: :btree
  end

  create_table "videos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title",                    limit: 1000,  null: false
    t.string   "sub_title",                limit: 1000
    t.string   "video_url",                limit: 1000,  null: false
    t.string   "slug",                     limit: 1000,  null: false
    t.string   "caption",                  limit: 2000
    t.string   "thumb_image_file_name"
    t.string   "thumb_image_content_type"
    t.integer  "thumb_image_file_size"
    t.datetime "thumb_image_updated_at"
    t.text     "additional_data",          limit: 65535
    t.integer  "order"
    t.boolean  "hidden"
    t.integer  "created_by"
    t.datetime "published_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

end
