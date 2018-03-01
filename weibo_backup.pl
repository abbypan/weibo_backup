#!/usr/bin/perl
use strict;
use warnings;

my ( $uid, $cookie ) = @ARGV;

our $GET_WEIBO_SUB = gen_get_url_sub( $cookie, 'weibo.cn' );
our $BASE_URL = "https://weibo.cn";

my %save_info = (
  'fav'             => "/fav/",
  'attitude'        => "/msg/attitude?rl=1",
  'comment/send'    => "/msg/comment/send?rl=1",
  'comment/receive' => "/msg/comment/receive?rl=1",
  'at/weibo'        => "/at/weibo?rl=1",
  'at/comment'      => "/at/comment",
  'profile'         => "/$uid/profile",
);

while ( my ( $dir, $page_num_url ) = each %save_info ) {
  backup_weibo( $GET_WEIBO_SUB, $dir, "$BASE_URL$page_num_url" );
}

#--

sub backup_weibo {
  my ( $weibo_sub, $dir, $page_num_url ) = @_;

  my $c     = $weibo_sub->( $page_num_url );
  my $max_n = extract_weibo_page_num( $c );

  my $last_f = 0;
  for my $i ( 1 .. $max_n ) {
    last if ( $last_f >= 1 );

    #last if ( $i > 5 );
    my $j     = $max_n + 1 - $i;
    my $fname = "$dir/$j.html";
    $last_f++ if ( -f $fname and -s $fname );
    my $iu = gen_weibo_page_url( $page_num_url, $i );
    $weibo_sub->( $iu, $fname );
    sleep 5;
  }
} ## end sub backup_weibo

sub extract_weibo_page_num {
  my ( $c ) = @_;
  my ( $n ) = $c =~ m#<input name="mp".+?value="(\d+)"#s;
  return $n;
}

sub gen_weibo_page_url {
  my ( $page_num_url, $n ) = @_;
  my $conn = $page_num_url =~ /\?/ ? '&' : '?';
  return "$page_num_url${conn}page=$n";
}

#--

sub gen_get_url_sub {
  my ( $cookie, $dom ) = @_;

  $cookie = init_cookie( $cookie, $dom );
  my $head = init_head( $cookie );

  return sub {
    my ( $url, $fname ) = @_;

    print "URL: $url\n";
    my $cmd = qq[curl -L -s $head "$url"];
    $cmd .= qq[ -o "$fname"] if ( $fname );

    #print $cmd, "\n";
    my $c = `$cmd`;
    return $c;
    }
} ## end sub gen_get_url_sub

sub init_head {
  my ( $cookie ) = @_;
  my %head = (
    'User-Agent'      => 'Mozilla/5.0 (X11; Linux x86_64; rv:50.0) Gecko/20100101 Firefox/50.0',
    'Accept'          => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language' => 'zh-CN,zh;q=0.8,zh-TW;q=0.6,en-US;q=0.4,en;q=0.2',
    'Connection'      => 'keep-alive',
    'Cookie'          => $cookie,
  );
  my $final_head = join( " ", map { qq[-H "$_: $head{$_}"] } keys( %head ) );
  return $final_head;
}

sub init_cookie {
  my ( $cookie, $dom ) = @_;

  if ( -f $cookie ) {                  #firefox sqlite3
    my $sqlite3_cookie = `sqlite3 "$cookie" "select name,value from moz_cookies where baseDomain='$dom'"`;
    my @segment = map { my @c = split /\|/; "$c[0]=$c[1]" } ( split /\n/, $sqlite3_cookie );
    $cookie = join( "; ", @segment );
  }

  return $cookie;
}
