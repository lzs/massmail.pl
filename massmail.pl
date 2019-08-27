#!/usr/bin/perl

use strict;
use Getopt::Long;

    my $sendmail_prog = '/usr/lib/sendmail -t';
    my $recipient_file;
    my $subject_text;
    my $email_content_file;

    if (GetOptions('r=s' => \$recipient_file,
                   's=s' => \$subject_text,
                   'e=s' => \$email_content_file,) == 0) {
        print STDERR "Stuffed!\n";
        exit 1;
    }

    if (!defined $email_content_file || !defined $recipient_file) {
        exit 1;
    }

    my $email_content = do {
        local $/ = undef;
        open my $fh, "<", $email_content_file
            or die "Cannot open email content file $email_content_file: $!";
            <$fh>;
    };

    $email_content = "Subject: $subject_text\n" . $email_content;



    open RECIPIENT, "<$recipient_file" or die "Cannot open recipient file $recipient_file: $!";
    while (<RECIPIENT>) {
        chomp;
        open MAIL, "|$sendmail_prog";
        print MAIL "To: $_\n";
        print MAIL $email_content;
        close MAIL;
        print "Sent to: $_\n";
    }
    close RECIPIENT;

