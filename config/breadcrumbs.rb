crumb :root do
  link "Home", root_path
end

crumb :post_relaxes do
  link "みんなの投稿", post_relaxes_path
  parent :root
end

crumb :post_relax do | user, post_relax |
  link "#{post_relax.user.name}の投稿", post_relax_path(post_relax)
  parent :post_relaxes
end

crumb :post_relax_edit do | user, post_relax |
  link "投稿編集"
  parent :post_relax, post_relax, user
end
crumb :users do
  link "ユーザー", users_path
  parent :root
end

crumb :user_show do | user |
  link "#{user.name}", user_path(user)
  parent :users
end

crumb :user_edit do | user |
  link "プロフィール編集"
  parent :user_show, user
end
# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).