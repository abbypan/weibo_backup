#!/usr/bin/perl
use strict;
use warnings;

our ( $UID, $COOKIE ) = @ARGV;

if ( -f $COOKIE ) {

  #firefox sqlite3
  my $sqlite3_cookie = `sqlite3 "$COOKIE" "select * from moz_cookies where baseDomain='weibo.cn'"`;
  my @segment = map { my @c = split /\|/; "$c[3]=$c[4]" } ( split /\n/, $sqlite3_cookie );
  $COOKIE = join( "; ", @segment );
}

my %head = (
  'User-Agent'      => 'Mozilla/5.0 (X11; Linux x86_64; rv:50.0) Gecko/20100101 Firefox/50.0',
  'Accept'          => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
  'Accept-Language' => 'zh-CN,zh;q=0.8,zh-TW;q=0.6,en-US;q=0.4,en;q=0.2',
  'Connection'      => 'keep-alive',
  'Cookie'          => $COOKIE,
);
our $HEAD = join( " ", map { qq[-H "$_: $head{$_}"] } keys( %head ) );

my %save_info = (
  'fav' => {
    page_num_url => "https://weibo.cn/fav/",
    page_url_sub => sub { "https://weibo.cn/fav/?page=$_[0]" }
  },
  'attitude' => {
    page_num_url => "https://weibo.cn/msg/attitude?rl=1",
    page_url_sub => sub { "https://weibo.cn/msg/attitude?rl=1&page=$_[0]" }
  },
  'comment/send' => {
    page_num_url => "https://weibo.cn/msg/comment/send?rl=1",
    page_url_sub => sub { "https://weibo.cn/msg/comment/send?rl=1&page=$_[0]" }
  },
  'comment/receive' => {
    page_num_url => "https://weibo.cn/msg/comment/receive?rl=1",
    page_url_sub => sub { "https://weibo.cn/msg/comment/receive?rl=1&page=$_[0]" }
  },
  'at/weibo' => {
    page_num_url => "https://weibo.cn/at/weibo?rl=1",
    page_url_sub => sub { "https://weibo.cn/at/weibo?rl=1&page=$_[0]" }
  },
  'at/comment' => {
    page_num_url => "https://weibo.cn/at/comment",
    page_url_sub => sub { "https://weibo.cn/at/comment?page=$_[0]" }
  },
  'profile' => {
    page_num_url => "https://weibo.cn/$UID/profile",
    page_url_sub => sub { "https://weibo.cn/$UID/profile?page=$_[0]" }
  },
);

while ( my ( $dir, $r ) = each %save_info ) {
  backup_weibo( $dir, $r->{page_num_url}, $r->{page_url_sub} );
}

sub backup_weibo {
  my ( $dir, $page_num_url, $page_url_sub ) = @_;

  my $max_n = get_weibo_page_num( $page_num_url );

  my $last_f = 0;
  for my $i ( 1 .. $max_n ) {
    last if ( $last_f >= 1 );

    #last if ( $i > 5 );
    my $j     = $max_n + 1 - $i;
    my $fname = "$dir/$j.html";
    $last_f++ if ( -f $fname and -s $fname );
    my $iu = $page_url_sub->( $i );
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

sub get_weibo_page {
  my ( $url, $fname ) = @_;

  print "URL: $url\n";
  my $cmd = qq[curl -L -s $HEAD "$url"];
  $cmd .= qq[ -o "$fname"] if ( $fname );

  #print $cmd, "\n";
  my $c = `$cmd`;
  return $c;
}
