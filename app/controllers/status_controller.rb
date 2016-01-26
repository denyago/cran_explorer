# Lets to check if application is up and running
# by returning HTTP OK.
class StatusController < ApplicationController
  def show
    render text: 'UP', status: 200
  end
end
