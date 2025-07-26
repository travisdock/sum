class PwaController < ApplicationController
  allow_unauthenticated_access
  
  def manifest
    render file: Rails.public_path.join("manifest.json"), 
           content_type: "application/manifest+json", 
           layout: false
  end
  
  def service_worker
    render file: Rails.public_path.join("service-worker.js"), 
           content_type: "application/javascript", 
           layout: false
  end
end