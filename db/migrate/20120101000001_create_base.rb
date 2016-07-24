class CreateBase < ActiveRecord::Migration
  def up

    create_table :sessions do |t|
      t.string :session_id,  null: false
      t.boolean :persistent, null: true
      t.text :data
      t.timestamps null: false
    end
    add_index :sessions, :session_id
    add_index :sessions, :updated_at
    add_index :sessions, :persistent

    create_table :users do |t|
      t.references :organization,                 null: true
      t.string :login,                limit: 100, null: false
      t.string :firstname,            limit: 100, null: true, default: ''
      t.string :lastname,             limit: 100, null: true, default: ''
      t.string :email,                limit: 140, null: true, default: ''
      t.string :image,                limit: 100, null: true
      t.string :image_source,         limit: 200, null: true
      t.string :web,                  limit: 100, null: true, default: ''
      t.string :password,             limit: 100, null: true
      t.string :phone,                limit: 100, null: true, default: ''
      t.string :fax,                  limit: 100, null: true, default: ''
      t.string :mobile,               limit: 100, null: true, default: ''
      t.string :department,           limit: 200, null: true, default: ''
      t.string :street,               limit: 120, null: true, default: ''
      t.string :zip,                  limit: 100, null: true, default: ''
      t.string :city,                 limit: 100, null: true, default: ''
      t.string :country,              limit: 100, null: true, default: ''
      t.string :address,              limit: 500, null: true, default: ''
      t.boolean :vip,                                         default: false
      t.boolean :verified,                        null: false, default: false
      t.boolean :active,                          null: false, default: true
      t.string :note,                 limit: 250, null: true, default: ''
      t.timestamp :last_login,                    null: true
      t.string :source,               limit: 200, null: true
      t.integer :login_failed,                    null: false, default: 0
      t.string :preferences,          limit: 8000, null: true
      t.integer :updated_by_id,                   null: false
      t.integer :created_by_id,                   null: false
      t.timestamps                                null: false
    end
    add_index :users, [:login], unique: true
    add_index :users, [:email]
    #add_index :users, [:email], unique: => true
    add_index :users, [:organization_id]
    add_index :users, [:image]
    add_index :users, [:department]
    add_index :users, [:phone]
    add_index :users, [:fax]
    add_index :users, [:mobile]
    add_index :users, [:source]
    add_index :users, [:created_by_id]

    create_table :signatures do |t|
      t.string :name,                 limit: 100,  null: false
      t.text :body,                   limit: 10.megabytes + 1, null: true
      t.boolean :active,                           null: false, default: true
      t.string :note,                 limit: 250,  null: true
      t.integer :updated_by_id,                    null: false
      t.integer :created_by_id,                    null: false
      t.timestamps                                 null: false
    end
    add_index :signatures, [:name], unique: true

    create_table :email_addresses do |t|
      t.integer :channel_id,                        null: true
      t.string  :realname,             limit: 250,  null: false
      t.string  :email,                limit: 250,  null: false
      t.boolean :active,                            null: false, default: true
      t.string  :note,                 limit: 250,  null: true
      t.string  :preferences,          limit: 2000, null: true
      t.integer :updated_by_id,                     null: false
      t.integer :created_by_id,                     null: false
      t.timestamps                                  null: false
    end
    add_index :email_addresses, [:email], unique: true

    create_table :groups do |t|
      t.references :signature,                      null: true
      t.references :email_address,                  null: true
      t.string :name,                   limit: 160, null: false
      t.integer :assignment_timeout,                null: true
      t.string :follow_up_possible,     limit: 100, null: false, default: 'yes'
      t.boolean :follow_up_assignment,              null: false, default: true
      t.boolean :active,                            null: false, default: true
      t.string :note,                   limit: 250, null: true
      t.integer :updated_by_id,                     null: false
      t.integer :created_by_id,                     null: false
      t.timestamps                                  null: false
    end
    add_index :groups, [:name], unique: true

    create_table :roles do |t|
      t.string :name,                   limit: 100, null: false
      t.boolean :active,                            null: false, default: true
      t.string :note,                   limit: 250, null: true
      t.integer :updated_by_id,                     null: false
      t.integer :created_by_id,                     null: false
      t.timestamps                                  null: false
    end
    add_index :roles, [:name], unique: true

    create_table :organizations do |t|
      t.string :name,                   limit: 100, null: false
      t.boolean :shared,                            null: false, default: true
      t.boolean :active,                            null: false, default: true
      t.string :note,                   limit: 250, null: true,  default: ''
      t.integer :updated_by_id,                     null: false
      t.integer :created_by_id,                     null: false
      t.timestamps                                  null: false
    end
    add_index :organizations, [:name], unique: true

    create_table :roles_users, id: false do |t|
      t.integer :user_id
      t.integer :role_id
    end
    add_index :roles_users, [:user_id]
    add_index :roles_users, [:role_id]

    create_table :groups_users, id: false do |t|
      t.integer :user_id
      t.integer :group_id
    end
    add_index :groups_users, [:user_id]
    add_index :groups_users, [:group_id]

    create_table :organizations_users, id: false do |t|
      t.integer :user_id
      t.integer :organization_id
    end
    add_index :organizations_users, [:user_id]
    add_index :organizations_users, [:organization_id]

    create_table :authorizations do |t|
      t.string :provider,             limit: 250, null: false
      t.string :uid,                  limit: 250, null: false
      t.string :token,                limit: 250, null: true
      t.string :secret,               limit: 250, null: true
      t.string :username,             limit: 250, null: true
      t.references :user, null: false
      t.timestamps                                null: false
    end
    add_index :authorizations, [:uid, :provider]
    add_index :authorizations, [:user_id]
    add_index :authorizations, [:username]

    create_table :locales do |t|
      t.string  :locale,              limit: 20,  null: false
      t.string  :alias,               limit: 20,  null: true
      t.string  :name,                limit: 255, null: false
      t.boolean :active,                          null: false, default: true
      t.timestamps                                null: false
    end
    add_index :locales, [:locale], unique: true
    add_index :locales, [:name], unique: true

    create_table :translations do |t|
      t.string :locale,               limit: 10,   null: false
      t.string :source,               limit: 255,  null: false
      t.string :target,               limit: 255,  null: false
      t.string :target_initial,       limit: 255,  null: false
      t.string :format,               limit: 20,   null: false, default: 'string'
      t.integer :updated_by_id,                    null: false
      t.integer :created_by_id,                    null: false
      t.timestamps                                 null: false
    end
    add_index :translations, [:source]
    add_index :translations, [:locale]

    create_table :object_lookups do |t|
      t.string :name,                 limit: 250, null: false
      t.timestamps                                null: false
    end
    add_index :object_lookups, [:name], unique: true

    create_table :type_lookups do |t|
      t.string :name,                 limit: 250, null: false
      t.timestamps                                null: false
    end
    add_index :type_lookups, [:name],   unique: true

    create_table :tokens do |t|
      t.references :user,                         null: false
      t.boolean :persistent
      t.string  :name,                limit: 100, null: false
      t.string  :action,              limit: 40,  null: false
      t.timestamps                                null: false
    end
    add_index :tokens, :user_id
    add_index :tokens, [:name, :action], unique: true
    add_index :tokens, :created_at
    add_index :tokens, :persistent

    create_table :packages do |t|
      t.string :name,                 limit: 250, null: false
      t.string :version,              limit: 50,  null: false
      t.string :vendor,               limit: 150, null: false
      t.string :state,                limit: 50,  null: false
      t.integer :updated_by_id,                   null: false
      t.integer :created_by_id,                   null: false
      t.timestamps                                null: false
    end
    create_table :package_migrations do |t|
      t.string :name,                 limit: 250, null: false
      t.string :version,              limit: 250, null: false
      t.timestamps                                null: false
    end

    create_table :taskbars do |t|
      t.integer :user_id,                           null: false
      t.datetime :last_contact,                     null: false
      t.string :client_id,                          null: false
      t.string :key,                   limit: 100,  null: false
      t.string :callback,              limit: 100,  null: false
      t.column :state,                 :text, limit: 2.megabytes + 1, null: true
      t.string :params,                limit: 2000, null: true
      t.integer :prio,                              null: false
      t.boolean :notify,                            null: false, default: false
      t.boolean :active,                            null: false, default: false
      t.timestamps                                  null: false
    end
    add_index :taskbars, [:user_id]
    add_index :taskbars, [:client_id]

    create_table :tags do |t|
      t.references :tag_item,                       null: false
      t.references :tag_object,                     null: false
      t.integer :o_id,                              null: false
      t.integer :created_by_id,                     null: false
      t.timestamps                                  null: false
    end
    add_index :tags, [:o_id]
    add_index :tags, [:tag_object_id]

    create_table :tag_objects do |t|
      t.string :name,                   limit: 250, null: false
      t.timestamps                                  null: false
    end
    add_index :tag_objects, [:name], unique: true

    create_table :tag_items do |t|
      t.string :name,                   limit: 250, null: false
      t.string :name_downcase,          limit: 250, null: false
      t.timestamps                                  null: false
    end
    add_index :tag_items, [:name_downcase]

    create_table :recent_views do |t|
      t.references :recent_view_object,             null: false
      t.integer :o_id,                              null: false
      t.integer :created_by_id,                     null: false
      t.timestamps                                  null: false
    end
    add_index :recent_views, [:o_id]
    add_index :recent_views, [:created_by_id]
    add_index :recent_views, [:created_at]
    add_index :recent_views, [:recent_view_object_id]

    create_table :activity_streams do |t|
      t.references :activity_stream_type,           null: false
      t.references :activity_stream_object,         null: false
      t.references :role,                           null: true
      t.references :group,                          null: true
      t.integer :o_id,                              null: false
      t.integer :created_by_id,                     null: false
      t.timestamps                                  null: false
    end
    add_index :activity_streams, [:o_id]
    add_index :activity_streams, [:created_by_id]
    add_index :activity_streams, [:role_id]
    add_index :activity_streams, [:group_id]
    add_index :activity_streams, [:created_at]
    add_index :activity_streams, [:activity_stream_object_id]
    add_index :activity_streams, [:activity_stream_type_id]

    create_table :histories do |t|
      t.references :history_type,                   null: false
      t.references :history_object,                 null: false
      t.references :history_attribute,              null: true
      t.integer :o_id,                              null: false
      t.integer :related_o_id,                      null: true
      t.integer :related_history_object_id,         null: true
      t.integer :id_to,                             null: true
      t.integer :id_from,                           null: true
      t.string :value_from,            limit: 500,  null: true
      t.string :value_to,              limit: 500,  null: true
      t.integer :created_by_id,                     null: false
      t.timestamps                                  null: false
    end
    add_index :histories, [:o_id]
    add_index :histories, [:created_by_id]
    add_index :histories, [:created_at]
    add_index :histories, [:history_object_id]
    add_index :histories, [:history_attribute_id]
    add_index :histories, [:history_type_id]
    add_index :histories, [:id_to]
    add_index :histories, [:id_from]
    add_index :histories, [:value_from], length: 255
    add_index :histories, [:value_to], length: 255

    create_table :history_types do |t|
      t.string :name,                   limit: 250, null: false
      t.timestamps                                  null: false
    end
    add_index :history_types, [:name], unique: true

    create_table :history_objects do |t|
      t.string :name,                   limit: 250, null: false
      t.string :note,                   limit: 250, null: true
      t.timestamps                                  null: false
    end
    add_index :history_objects, [:name], unique: true

    create_table :history_attributes do |t|
      t.string :name,                   limit: 250, null: false
      t.timestamps                                  null: false
    end
    add_index :history_attributes, [:name], unique: true

    create_table :settings do |t|
      t.string :title,                  limit: 200,  null: false
      t.string :name,                   limit: 200,  null: false
      t.string :area,                   limit: 100,  null: false
      t.string :description,            limit: 2000, null: false
      t.string :options,                limit: 2000, null: true
      t.string :state_current,          limit: 2000, null: true
      t.string :state_initial,          limit: 2000, null: true
      t.boolean :frontend,                           null: false
      t.string :preferences,            limit: 2000, null: true
      t.timestamps                                   null: false
    end
    add_index :settings, [:name], unique: true
    add_index :settings, [:area]
    add_index :settings, [:frontend]

    create_table :stores do |t|
      t.references :store_object,               null: false
      t.references :store_file,                 null: false
      t.integer :o_id,              limit: 8,   null: false
      t.string :preferences,        limit: 2500, null: true
      t.string :size,               limit: 50,  null: true
      t.string :filename,           limit: 250, null: false
      t.integer :created_by_id,                 null: false
      t.timestamps                              null: false
    end
    add_index :stores, [:store_object_id, :o_id]

    create_table :store_objects do |t|
      t.string :name,               limit: 250, null: false
      t.string :note,               limit: 250, null: true
      t.timestamps                              null: false
    end
    add_index :store_objects, [:name], unique: true

    create_table :store_files do |t|
      t.string :sha,                limit: 128, null: false
      t.string :provider,           limit: 20,  null: true
      t.timestamps                              null: false
    end
    add_index :store_files, [:sha], unique: true
    add_index :store_files, [:provider]

    create_table :store_provider_dbs do |t|
      t.string :sha,                limit: 128,            null: false
      t.binary :data,               limit: 200.megabytes,  null: true
      t.timestamps                                         null: false
    end
    add_index :store_provider_dbs, [:sha], unique: true

    create_table :avatars do |t|
      t.integer :o_id,                          null: false
      t.integer :object_lookup_id,              null: false
      t.boolean :default,                       null: false, default: false
      t.boolean :deletable,                     null: false, default: true
      t.boolean :initial,                       null: false, default: false
      t.integer :store_full_id,                 null: true
      t.integer :store_resize_id,               null: true
      t.string :store_hash,         limit: 32,  null: true
      t.string :source,             limit: 100, null: false
      t.string :source_url,         limit: 512, null: true
      t.integer :updated_by_id,                 null: false
      t.integer :created_by_id,                 null: false
      t.timestamps                              null: false
    end
    add_index :avatars, [:o_id, :object_lookup_id]
    add_index :avatars, [:store_hash]
    add_index :avatars, [:source]
    add_index :avatars, [:default]

    create_table :online_notifications do |t|
      t.integer :o_id,                          null: false
      t.integer :object_lookup_id,              null: false
      t.integer :type_lookup_id,                null: false
      t.integer :user_id,                       null: false
      t.boolean :seen,                          null: false, default: false
      t.integer :updated_by_id,                 null: false
      t.integer :created_by_id,                 null: false
      t.timestamps                              null: false
    end
    add_index :online_notifications, [:user_id]
    add_index :online_notifications, [:seen]
    add_index :online_notifications, [:created_at]
    add_index :online_notifications, [:updated_at]

    create_table :schedulers do |t|
      t.column :name,           :string, limit: 250,   null: false
      t.column :method,         :string, limit: 250,   null: false
      t.column :period,         :integer,              null: true
      t.column :running,        :integer,              null: false, default: false
      t.column :last_run,       :timestamp,            null: true
      t.column :prio,           :integer,              null: false
      t.column :pid,            :string, limit: 250,   null: true
      t.column :note,           :string, limit: 250,   null: true
      t.column :active,         :boolean,              null: false, default: false
      t.column :updated_by_id,  :integer,              null: false
      t.column :created_by_id,  :integer,              null: false
      t.timestamps                                     null: false
    end
    add_index :schedulers, [:name], unique: true

    create_table :calendars do |t|
      t.string  :name,                   limit: 250, null: true
      t.string  :timezone,               limit: 250, null: true
      t.string  :business_hours,         limit: 3000, null: true
      t.boolean :default,                            null: false, default: false
      t.string  :ical_url,               limit: 500, null: true
      t.text    :public_holidays,        limit: 500.kilobytes + 1, null: true
      t.text    :last_log,               limit: 500.kilobytes + 1, null: true
      t.timestamp :last_sync,            null: true
      t.integer :updated_by_id,          null: false
      t.integer :created_by_id,          null: false
      t.timestamps                       null: false
    end
    add_index :calendars, [:name], unique: true

    create_table :user_devices do |t|
      t.references :user,             null: false
      t.string  :name,                 limit: 250, null: false
      t.string  :os,                   limit: 150, null: true
      t.string  :browser,              limit: 250, null: true
      t.string  :location,             limit: 150, null: true
      t.string  :device_details,       limit: 2500, null: true
      t.string  :location_details,     limit: 2500, null: true
      t.string  :fingerprint,          limit: 160, null: true
      t.string  :user_agent,           limit: 250, null: true
      t.string  :ip,                   limit: 160, null: true
      t.timestamps                                 null: false
    end
    add_index :user_devices, [:user_id]
    add_index :user_devices, [:os, :browser, :location]
    add_index :user_devices, [:fingerprint]
    add_index :user_devices, [:updated_at]
    add_index :user_devices, [:created_at]

    create_table :external_credentials do |t|
      t.string :name
      t.string :credentials, limit: 2500, null: false
      t.timestamps                        null: false
    end

    create_table :object_manager_attributes do |t|
      t.references :object_lookup,                         null: false
      t.column :name,               :string, limit: 200,   null: false
      t.column :display,            :string, limit: 200,   null: false
      t.column :data_type,          :string, limit: 100,   null: false
      t.column :data_option,        :string, limit: 8000,  null: true
      t.column :data_option_new,    :string, limit: 8000,  null: true
      t.column :editable,           :boolean,              null: false, default: true
      t.column :active,             :boolean,              null: false, default: true
      t.column :screens,            :string, limit: 2000,  null: true
      t.column :to_create,          :boolean,              null: false, default: false
      t.column :to_migrate,         :boolean,              null: false, default: false
      t.column :to_delete,          :boolean,              null: false, default: false
      t.column :to_config,          :boolean,              null: false, default: false
      t.column :position,           :integer,              null: false
      t.column :created_by_id,      :integer,              null: false
      t.column :updated_by_id,      :integer,              null: false
      t.timestamps                                         null: false
    end
    add_index :object_manager_attributes, [:object_lookup_id, :name],   unique: true
    add_index :object_manager_attributes, [:object_lookup_id]

    create_table :delayed_jobs, force: true do |t|
      t.integer  :priority, default: 0      # Allows some jobs to jump to the front of the queue
      t.integer  :attempts, default: 0      # Provides for retries, but still fail eventually.
      t.text     :handler                      # YAML-encoded string of the object that will do work
      t.text     :last_error                   # reason for last failure (See Note below)
      t.datetime :run_at                       # When to run. Could be Time.zone.now for immediately, or sometime in the future.
      t.datetime :locked_at                    # Set when a client is working on this object
      t.datetime :failed_at                    # Set when all retries have failed (actually, by default, the record is deleted instead)
      t.string   :locked_by                    # Who is working on this object (if locked)
      t.string   :queue                        # The name of the queue this job is in
      t.timestamps null: false
    end

    add_index :delayed_jobs, [:priority, :run_at], name: 'delayed_jobs_priority'

  end
end
