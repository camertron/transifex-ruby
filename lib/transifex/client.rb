require 'transifex/request'

module Transifex
  class Client
    include Transifex::Request

    def initialize(options = {})
      set_credentials(
        options[:username] || Transifex.username,
        options[:password] || Transifex.password
      )
    end

    def projects
      get('/projects/').map do |project|
        Transifex::Project.new(project).tap {|p| p.client = self }
      end
    end

    def project(slug)
      Transifex::Project.new(get("/project/#{slug}/")).tap do |project|
        project.client = self
      end
    end

    def resources(project_slug)
      get("project/#{project_slug}/resources/").map do |resource|
        Transifex::Resource.new(project_slug, resource).tap do |resource|
          resource.client = self
        end
      end
    end

    def resource(project_slug, resource_slug)
      resource = get("project/#{project_slug}/resource/#{resource_slug}")
      Transifex::Resource.new(project_slug, resource).tap do |resource|
        resource.client = self
      end
    end

    def languages(project_slug)
      get("/project/#{project_slug}/languages/").map do |language|
        Transifex::Language.new(project_slug, language).tap do |language|
          language.client = self
        end
      end
    end

    def stats(project_slug, resource_slug)
      url = "/project/#{project_slug}/resource/#{resource_slug}/stats/"

      get(url).each_with_object({}) do |(lang, stats), ret|
        ret[lang] = Transifex::Stats.new(stats).tap do |r|
          r.client = self
        end
      end
    end
  end
end
