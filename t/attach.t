use Test::More tests => 7;
use File::Slurp;
BEGIN { unlink("t/test.db"); }
use Email::Store 
    ("dbi:SQLite:dbname=t/test.db", "", "", { sqlite_handle_binary_nulls => 1 } );
Email::Store->setup;
ok(1, "Set up");

my $data = read_file("t/attach-test");
my $mail = Email::Store::Mail->store($data);
my @att = $mail->attachments;
is (@att, 2, "Has two attachments");
my $new_msg = do {local $/; <DATA> };
my $msg = $mail->message;
$msg =~ s/Message-ID:.*//;
$new_msg =~ s/Message-ID:.*//;
is ($msg, $new_msg, "Message with crap stripped");
is($att[0]->content_type, "application/x-tex");
is($att[0]->filename, "foo.tex");
is($att[0]->payload, "Foo bar baz\n\n");
is($att[1]->content_type, "image/png");
__DATA__
From: Simon Cozens <simon@simon-cozens.org>
To: test@test.com
Bcc: lathos@gmail.com
Subject: Test attachment
Mime-Version: 1.0
X-Mutt-Fcc: =outbox-200406
Message-ID: mailbox-11802-1086626757@alison.home
Content-Type: text/plain
Content-Length: 60
Lines: 1
Content-Transfer-Encoding: 8bit

I am attaching two pointless attachments for your pleasure.
