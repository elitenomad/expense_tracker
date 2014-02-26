class MembershipsController < ApplicationController

def create
  @group = Group.find_by_id params[:group_id]
    # validate if user is present
    # Two conditions arise
    # User in the database. he will be just added to the group
    # User not in the database. If this is the case we need to
    # figure a way out to adjust user in a group
    user_count = User.where(email: params[:emailid]).count
    group_users_count = @group.users.where(email: params[:emailid]).count
    if(user_count >= 1)
      user = User.find_by(email: params[:emailid])
      if (group_users_count == 0)
        @group.users << user
        redirect_to groups_path(@group), alert: "User is successfully added to group"
      else
        redirect_to groupuser_path(@group), alert: "User is already added to group"
      end
    else
        # Need to perform another logic
        fail
    end
end

end