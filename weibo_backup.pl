#!/usr/bin/perl

our ($UID, $COOKIE) = @ARGV;

my %head = (
    'User-Agent' =>
      'Mozilla/5.0 (X11; Linux x86_64; rv:50.0) Gecko/20100101 Firefox/50.0',
    'Accept' =>
      'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language' => 'zh-CN,zh;q=0.8,zh-TW;q=0.6,en-US;q=0.4,en;q=0.2',
    'Connection'      => 'keep-alive',
    'Cookie'          => $COOKIE,
);
my $HEAD = join( " ", map { qq[-H "$_: $head{$_}"] } keys(%head) );

backup_weibo( \&profile_num_url,    \&profile_page_url,    'profile' );
backup_weibo( \&at_num_url,         \&at_page_url,         'at/weibo' );
backup_weibo( \&at_comment_num_url, \&at_comment_page_url, 'at/comment' );
backup_weibo( \&comment_num_url,    \&comment_page_url,    'comment/receive' );
backup_weibo( \&comment_send_num_url, \&comment_send_page_url, 'comment/send' );
backup_weibo( \&attitude_num_url,   \&attitude_page_url,   'attitude' );
backup_weibo( \&fav_num_url,        \&fav_page_url,        'fav' );

sub backup_weibo {
    my ( $num_sub, $page_sub, $dir ) = @_;

    my $nu    = $num_sub->();
    my $max_n = get_weibo_page_num($nu);

    my $last_f = 0;
    for my $i ( 1 .. $max_n ) {
        last if ( $last_f >= 1 );
        #last if ( $i > 5 );
        my $j     = $max_n + 1 - $i;
        my $fname = "$dir/$j.html";
        $last_f++ if ( -f $fname );
        my $iu = $page_sub->($i);
        get_weibo_page( $iu, $fname );
        sleep 3;
    }
}

sub get_weibo_page_num {
    my ($u) = @_;
    my $c = get_weibo_page($u);
    #print $c, "\n";
    my ($n) = $c =~ m#<input name="mp".+?value="(\d+)"#s;
    return $n;
}

sub get_weibo_page {
    my ( $url, $fname ) = @_;

    print "URL: $url\n";
    my $cmd = qq[curl -s $HEAD "$url"];
    $cmd .= qq[ -o "$fname"] if ($fname);

    #print $cmd, "\n";
    my $c = `$cmd`;
    return $c;
}

sub fav_num_url {
    my $u = "http://weibo.cn/fav/";
}

sub fav_page_url {
    my ($n) = @_;
    my $u = "http://weibo.cn/fav/?page=$n";
}

sub attitude_num_url {
    my $u = "http://weibo.cn/msg/attitude?rl=1";
}

sub attitude_page_url {
    my ($n) = @_;
    my $u = "http://weibo.cn/msg/attitude?rl=1&page=$n";
}

sub comment_send_num_url {
    my $u = "http://weibo.cn/msg/comment/send?rl=1";
}

sub comment_send_page_url {
    my ($n) = @_;
    my $u = "http://weibo.cn/msg/comment/send?rl=1&page=$n";
}

sub comment_num_url {
    my $u = "http://weibo.cn/msg/comment/receive?rl=1";
}

sub comment_page_url {
    my ($n) = @_;
    my $u = "http://weibo.cn/msg/comment/receive?rl=1&page=$n";
}

sub at_num_url {
    my $u = "http://weibo.cn/at/weibo?rl=1";
}

sub at_page_url {
    my ($n) = @_;
    my $u = "http://weibo.cn/at/weibo?rl=1&page=$n";
}

sub at_comment_num_url {
    my $u = "http://weibo.cn/at/comment";
}

sub at_comment_page_url {
    my ($n) = @_;
    my $u = "http://weibo.cn/at/comment?page=$n";
}

sub profile_num_url {
    my $u = "http://weibo.cn/$UID/profile";
}

sub profile_page_url {
    my ($n) = @_;
    my $u = "http://weibo.cn/$UID/profile?page=$n";
}
