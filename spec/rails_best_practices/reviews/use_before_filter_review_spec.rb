require 'spec_helper'

describe RailsBestPractices::Reviews::UseBeforeFilterReview do
  let(:runner) { RailsBestPractices::Core::Runner.new(:reviews => RailsBestPractices::Reviews::UseBeforeFilterReview.new) }

  it "should use before_filter" do
    content = <<-EOF
    class PostsController < ApplicationController

      def show
        @post = current_user.posts.find(params[:id])
      end

      def edit
        @post = current_user.posts.find(params[:id])
      end

      def update
        @post = current_user.posts.find(params[:id])
        @post.update_attributes(params[:post])
      end

      def destroy
        @post = current_user.posts.find(params[:id])
        @post.destroy
      end

    end
    EOF
    runner.review('app/controllers/posts_controller.rb', content)
    runner.should have(1).errors
    runner.errors[0].to_s.should == "app/controllers/posts_controller.rb:3,7,11,16 - use before_filter for show,edit,update,destroy"
  end

  it "should not use before_filter" do
    content = <<-EOF
    class PostsController < ApplicationController
      before_filter :find_post, :only => [:show, :edit, :update, :destroy]

      def update
        @post.update_attributes(params[:post])
      end

      def destroy
        @post.destroy
      end

      protected

      def find_post
        @post = current_user.posts.find(params[:id])
      end
    end
    EOF
    runner.review('app/controllers/posts_controller.rb', content)
    runner.should have(0).errors
  end

  it "should not use before_filter by nil" do
    content = <<-EOF
    class PostsController < ApplicationController

      def show
      end

      def edit
      end

      def update
      end

      def destroy
      end

    end
    EOF
    runner.review('app/controllers/posts_controller.rb', content)
    runner.should have(0).errors
  end

  it "should not use before_filter for protected/private methods" do
    content =<<-EOF
    class PostsController < ApplicationController
      protected
        def load_comments
          load_post
          @comments = @post.comments
        end

        def load_user
          load_post
          @user = @post.user
        end
    end
    EOF
    runner.review('app/controllers/posts_controller.rb', content)
    runner.should have(0).errors
  end
end