module MainHelper
  def self.included(klass)
    # klass.helper_method [:my_helper_method] rescue "" # here your methods accessible from views
  end

  # here all actions on going to active
  # you can run sql commands like this:
  # results = ActiveRecord::Base.connection.execute(query);
  # plugin: plugin model
  def tessitura_on_active(plugin)
  end

  # here all actions on going to inactive
  # plugin: plugin model
  def tessitura_on_inactive(plugin)
  end

  # here all actions to upgrade for a new version
  # plugin: plugin model
  def tessitura_on_upgrade(plugin)
  end

  # hook listener to add settings link below the title of current plugin (if it is installed)
  # args: {plugin (Hash), links (Array)}
  # permit to add unlimmited of links...
  def tessitura_on_plugin_options(args)
    args[:links] << link_to('Settings', admin_plugins_tessitura_settings_path)
  end
  
  def tessitura_custom_fields(args)
    args[:fields][:season_production] = {
      key: "season_production",
      label: "Season Production",
      render: plugin_view('custom_fields/season_production.html.erb'),
      options: {
          required: false,
          multiple: false,
          default_value: '',
          show_frontend: true
      }
    }
    args[:fields][:cast_member] = {
      key: "cast_member",
      label: "Cast Member",
      render: plugin_view('custom_fields/cast_member.html.erb'),
      options: {
          required: false,
          multiple: true,
          default_value: '',
          show_frontend: true
      }
    }
    args[:fields][:year_picker] = {
      key: "year_picker",
      label: "Year Picker",
      render: plugin_view('custom_fields/year_picker.html.erb'),
      options: {
          required: false,
          default_value: '',
          show_frontend: true
      }
    }
  end
  
  def tessitura_admin_before_load
    append_asset_libraries({"tessitura"=> { js: ["tinymce/plugins/bootstrap/plugin"]}})
  end
  
end
