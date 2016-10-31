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

class SearchWithUserService
  def initialize(searchable_class, user)
    @searchable_class = searchable_class
    @user = user
  end

  def search(params)
    if @user.admin?
      search_result = @searchable_class.search(params[:search]).page(params[:page])
    else
      search_result = @searchable_class.where(user: @current_user).search(params[:search]).page(params[:page])
    end

    search_result
  end
end
