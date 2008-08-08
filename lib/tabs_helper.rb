# TabsForRails
module TabsHelper
  
  def self.included(base)
    base.extend(ClassMethods)
  end

  #
  # Example:
  #
  #   # Controller
  #   class DashboardController < ApplicationController
  #     current_tab :mydashboard
  #   end
  #
  #   # View
  #   <% tabs do |tab| %>
  #     <%= tab.account 'Account', account_path, :style => 'float: right' %>
  #     <%= tab.users 'Users', users_path, :style => 'float: right' %>
  #     <%= tab.mydashboard 'Dashboard', '/' %>
  #     <%= tab.projects 'Projects', projects_path %>
  #   <% end %>
  #
  module ClassMethods
    def current_tab(name, options = {})
      before_filter(options) do |controller|
        controller.instance_variable_set('@current_tab', name)
      end
    end
  end

  module Config
    class Core
      # global level configuration
      # --------------------------

      # configures where the ActiveScaffold plugin itself is located. there is no instance version of this.
      cattr_accessor :plugin_directory
      @@plugin_directory = File.expand_path(__FILE__).match(/vendor\/plugins\/([^\/]*)/)[1]

      # lets you specify a global ActiveScaffold frontend.
      cattr_accessor :frontend
      @@frontend = :default

      # lets you specify a global ActiveScaffold theme for your frontend.
      cattr_accessor :theme
      @@theme = :default

      # must be a class method so the layout doesn't depend on a controller that uses active_scaffold
      # note that this is unaffected by per-controller frontend configuration.
      def self.asset_path(filename, frontend = self.frontend)
        "tabs/#{frontend}/#{filename}"
      end
    end
  end

  module Helpers
    module ViewHelpers
      class Tab
        def initialize(context)
          @context = context
        end

        def current_tab
          @context.instance_variable_get('@current_tab')
        end

        def method_missing(tab, name, options = {}, html_options = {})
          html_options[:class].nil? ? html_options[:class] = 'current' : html_options[:class] << 'current' if tab.to_s == current_tab.to_s
          @context.link_to(name, options, html_options)
        end
      end

      def tabs(&block)
        raise ArgumentError, "Missing block" unless block_given?

        concat('<ul id="tabs">', proc.binding)
        yield Tab.new(self)
        concat('</ul>', proc.binding)
      end

      def tabs_includes(frontend = :default)
        stylesheet_link_tag(TabsHelper::Config::Core.asset_path("tabs.css", frontend))
      end
    end
  end
end
