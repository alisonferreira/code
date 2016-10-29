################################################################################
# The MIT License (MIT)
#
# Copyright (c) 2016 C.O.D.E
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
################################################################################

class UsersController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => [:profile, :update]
  # skip_authorize_resource :put, :only => :update

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @users = User.search(params[:search]).page(params[:page])
    respond_with(@users)
  end

  def show
    respond_with(@user)
  end

  def new
    @user = User.new
    respond_with(@user)
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, flash: { success: 'Usuário cadastro com sucesso' }
    else
      flash.now[:error] = @user.errors.full_messages
      render :new
    end
  end

  def update
    if @user.update(check_password(user_params))
      if current_user.admin?
        redirect_to users_path, flash: { success: 'Usuário atualizado com sucesso' }
      else
        redirect_to :back, flash: { success: 'Usuário atualizado com sucesso' }
      end
    else
      flash.now[:error] = @user.errors.full_messages
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path, flash: { success: 'Usuário excluído com sucesso' }
    else
      redirect_to users_path, flash: { error: 'Erro ao excluir usuário' }
    end
  end

  def profile
    @user = User.find(current_user)
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def check_password(user_params)
      if user_params[:password].empty?
        user_params.delete(:password)
        user_params.delete(:password_confirmation)
        user_params
      else
        user_params
      end
    end

    def user_params
      params.require(:user).permit(
        :name, :admin, :email, :password, :password_confirmation, :status
      )
    end
end
