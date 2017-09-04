# My first cro program, a server that supports the following URLs:
#   http://localhost:10000
#   http://localhost:10000/greet/Joe
#   http://localhost:10000/articles/Joe/anarticle

# How to install Emacs Perl 6 mode
#   http://linuxtot.com/perl6-major-mode-for-emacs-how-to-install/

use Cro::HTTP::Router;
use Cro::HTTP::Server;
my $application = route {
    get -> {
        content 'text/html', qq:to/END/;
	Hello World! This is produced by <a href="https://github.com/kaicarver/hellocro">Cro</a><br>
	<a href="/greet/Joe">greet</a><br>
	<a href="/articles/Joe/An article">an article</a><br>
	END
    }
    get -> 'greet', $name {
        content 'text/plain', "Hello, $name!";
    }
    get -> 'articles', $author, $name {
	content 'text/html', "article: $author: $name";
    }    
}

my Cro::Service $service = Cro::HTTP::Server.new:
    :host<localhost>, :port<10000>, :$application;

$service.start;

react whenever signal(SIGINT) {
    $service.stop;
    exit;
}
