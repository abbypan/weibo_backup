#!/usr/bin/perl
use strict;
use warnings;

my ( $uid, $cookie ) = @ARGV;

our $HEAD = init_head( $cookie );

my %save_info = (
  'fav'             => "https://weibo.cn/fav/",
  'attitude'        => "https://weibo.cn/msg/attitude?rl=1",
  'comment/send'    => "https://weibo.cn/msg/comment/send?rl=1",
  'comment/receive' => "https://weibo.cn/msg/comment/receive?rl=1",
  'at/weibo'        => "https://weibo.cn/at/weibo?rl=1",
  'at/comment'      => "https://weibo.cn/at/comment",
  'profile'         => "https://weibo.cn/$uid/profile",
);

while ( my ( $dir, $page_num_url ) = each %save_info ) {
  backup_weibo( $dir, $page_num_url );
}

sub backup_weibo {
  my ( $dir, $page_num_url ) = @_;

  my $max_n = get_weibo_page_num( $page_num_url );

  my $last_f = 0;
  for my $i ( 1 .. $max_n ) {
    last if ( $last_f >= 1 );

    #last if ( $i > 5 );
    my $j     = $max_n + 1 - $i;
    my $fname = "$dir/$j.html";
    $last_f++ if ( -f $fname and -s $fname );
    my $iu = get_weibo_page_url( $page_num_url, $i );
    get_weibo_page( $iu, $fname );
    sleep 5;
  }
} ## end sub backup_weibo

sub get_weibo_page_num {
  my ( $u ) = @_;
  my $c = get_weibo_page( $u );

  #print $c, "\n";
  my ( $n ) = $c =~ m#<input name="mp".+?value="(\d+)"#s;
  return $n;
}

sub get_weibo_page_url {
  my ( $page_num_url, $n ) = @_;
  my $conn = $page_num_url =~ /\?/ ? '&' : '?';
  return "$page_num_url${conn}page=$n";
}

sub get_weibo_page {
  my ( $url, $fname ) = @_;

  print "URL: $url\n";
  my $cmd = qq[curl -L -s $HEAD "$url"];
  $cmd .= qq[ -o "$fname"] if ( $fname );

  #print $cmd, "\n";
  my $c = `$cmd`;
  return $c;
}

sub init_head {
  my ( $cookie ) = @_;

  $cookie = init_cookie( $cookie );

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
  my ( $cookie ) = @_;

  if ( -f $cookie ) {                  #firefox sqlite3
    my $sqlite3_cookie = `sqlite3 "$cookie" "select * from moz_cookies where baseDomain='weibo.cn'"`;
    my @segment = map { my @c = split /\|/; "$c[3]=$c[4]" } ( split /\n/, $sqlite3_cookie );
    $cookie = join( "; ", @segment );
  }

  return $cookie;
}
