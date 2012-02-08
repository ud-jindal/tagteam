ActsAsTaggableOn::Tag.class_eval do

  def contexts
    contexts = ActsAsTaggableOn::Tagging.select('context').where('tag_id = ? and context != ?',self.id,'tags').group('context')
    (contexts.length == 0) ? [] : contexts.collect{|tg| tg.context} 
  end

  def mini_icon
    %q|<span class="ui-silk inline ui-silk-tag-blue"></span>|
  end

  def items(hub = Hub.first)
    taggings.find(:all, :include => [:taggable], :conditions => {:context => hub.tagging_key.to_s}, :order => 'created_at desc').collect{|tg| tg.taggable}
  end

end

ActsAsTaggableOn::Tag.instance_eval do
  has_many :add_tag_filters
  has_many :modify_tag_filters
  has_many :delete_tag_filters
  searchable do
    text :name
    string :contexts, :multiple => true
    string :name
  end
end