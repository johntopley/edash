require 'dm-core'
require 'dm-timestamps'
require 'md5'
require 'json'

module Dashboard
  class Project
    include DataMapper::Resource
    property :name,            String, :key => true
    property :author,          String
    property :status,          String
    property :author_gravatar, String
    property :updated_at,      DateTime
    
    def self.create_or_update(params)
      name    = params[:project]
      author  = params[:author]
      status  = params[:status]
      
      project = Project.get(name)
      if project.nil?
        project = Project.create(:name => name,
                                 :author => author, :status => status)
      else
        project.update(:author => author, :status => status)
      end
      project.author_gravatar = project.gravatar_for_author
      project.save
      project
    end
    
    def gravatar_for_author
      return if author.nil? || author.size == 0
      "http://www.gravatar.com/avatar/#{MD5::md5(author.match(/<(.*)>/)[1].gsub(' ', '+'))}?s=50"
    end
    
    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => name,
        'author' => author,
        'status' => status, 
        'author_gravatar' => author_gravatar
      }.to_json(*a)
    end
  end
end
