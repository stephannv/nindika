# frozen_string_literal: true

class HiddenItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    result = HiddenItems::Create.result(user: current_user, item_id: params[:item_id])

    if result.success?
      redirect_back_or_to root_path, allow_other_host: false, success: t('.success')
    else
      redirect_back_or_to root_path, allow_other_host: false, danger: t('.error')
    end
  end

  def destroy
    result = HiddenItems::Destroy.result(user: current_user, item_id: params[:item_id])

    if result.success?
      redirect_back_or_to root_path, allow_other_host: false, success: t('.success')
    else
      redirect_back_or_to root_path, allow_other_host: false, danger: t('.error')
    end
  end
end
