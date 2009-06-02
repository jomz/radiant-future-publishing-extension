class FuturePublishingExtension < Radiant::Extension
  version "1.0"
  description "Allows you to publish a page at a certain time in the future."
  url "http://jomz.gorilla-webdesign.be"
    
  def activate
    Page.module_eval &FuturePublishing::PageExt
  end
  
  def deactivate
  end
  
end
