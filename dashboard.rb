require 'sinatra'
require 'haml'
PROJECTS = {'moo' => '?',
	    'moo2' => '?', 
	    'shavers' => '?',
	    'cfi' => '?'}

get '/?' do
	haml :index
end

post '/build/:project/:status' do |project, status|
	PROJECTS[project] = status
end

__END__
@@index
%html
	%head
		%title= "CI Dashboard"
		:javascript
			window.setTimeout('window.location.reload(true)', 20000)
%body{:style => 'font-size:3em;font-family:sans-serif'}
	%h2= "CI Dashboard"
	%ul
	- PROJECTS.each do |name, status|
		%li
			%a{:href => "/#{name}"}= "#{name}"
			(#{status})
