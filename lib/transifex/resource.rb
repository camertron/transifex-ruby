module Transifex
  class Resource
    attr_accessor :client, :categories, :i18n_type, :source_language_code, :slug, :name

    def initialize(project_slug, transifex_data)
      @project_slug = project_slug
      @name = transifex_data[:name]
      @categories = transifex_data[:categories]
      @i18n_type = transifex_data[:i18n_type]
      @source_language_code = transifex_data[:source_language_code]
      @slug = transifex_data[:slug]
    end

    def content
      client.get("/project/#{@project_slug}/resource/#{@slug}/content/")
    end

    def translation(lang)
      client.get("/project/#{@project_slug}/resource/#{@slug}/translation/#{lang}/")
    end

    def stats(lang = nil)
      base_url = "/project/#{@project_slug}/resource/#{@slug}/stats/"

      stats = if lang
        { lang => client.get("#{base_url}#{lang}/") }
      else
        client.get(base_url)
      end

      stats.each_with_object({}) do |(lang, stats), ret|
        ret[lang] = Transifex::Stats.new(stats).tap do |r|
          r.client = client
        end
      end
    end
  end
end
