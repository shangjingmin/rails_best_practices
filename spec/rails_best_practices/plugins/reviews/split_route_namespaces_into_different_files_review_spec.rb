require '../../spec_helper'
require 'rails_best_practices'
#require '../../../lib/rails_best_practices/plugins/reviews/split_route_namespaces_into_different_files_review'
require 'rails_best_practices/plugins/reviews/split_route_namespaces_into_different_files_review'

describe RailsBestPractices::Plugins::Reviews::SplitRouteNamespacesIntoDifferentFilesReview do
  let(:runner) { RailsBestPractices::Core::Runner.new(:reviews => RailsBestPractices::Plugins::Reviews::SplitRouteNamespacesIntoDifferentFilesReview.new) }

  it "should split route namespaces into different files" do
    content =<<-EOF
ActionController::Routing::Routes.draw do |map|
  map.resources :posts
  map.resources :comments
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'create'

  map.namespace :developer do |dev|
    dev.resources :posts
    dev.resources :comments
    dev.logout '/logout', :controller => 'sessions', :action => 'destroy'
    dev.login '/login', :controller => 'sessions', :action => 'create'
  end

  map.namespace :admin do |admin|
    admin.resources :posts
    admin.resources :comments
    admin.logout '/logout', :controller => 'sessions', :action => 'destroy'
    admin.login '/login', :controller => 'sessions', :action => 'create'
  end

  map.namespace :api do |api|
    api.resources :posts
    api.resources :comments
    api.logout '/logout', :controller => 'sessions', :action => 'destroy'
    api.login '/login', :controller => 'sessions', :action => 'create'
  end
end
    EOF
    runner.review('app/models/user.rb', content)
    runner.should have(3).errors
    runner.errors[0].to_s.should == "app/models/user.rb:4 - not use RAILS_ROOT"
  end

  it "should split route namespaces into different files" do
    content =<<-EOF
ActionController::Routing::Routes.draw do |map|
  map.resources :posts
  map.resources :comments
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'create'

  map.namespace1 :developer do |dev|
    dev.resources :posts
    dev.resources :comments
    dev.logout '/logout', :controller => 'sessions', :action => 'destroy'
    dev.login '/login', :controller => 'sessions', :action => 'create'
  end
end
    EOF
    runner.review('app/models/user.rb', content)
    runner.should have(0).errors
  end
end
