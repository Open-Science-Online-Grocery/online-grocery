# frozen_string_literal: true

class StoresController < ApplicationController
  skip_before_action :authenticate_user!

  layout 'basic'

  def show
  end

  def home
    render :show
  end

  def product
    render :show
  end

  def search
    render :show
  end

  def checkout
    render :show
  end

  def thank_you
    render :show
  end
end
