use ExtUtils::MakeMaker;

WriteMakefile
(
    'NAME'         => 'Time::Local::2074',
    'VERSION_FROM' => '2074.pm',
    'PREREQ_PM'    => {
        'Time::Local' => 0,
    },
    (
        $] >= 5.005 ?
        (
            ABSTRACT_FROM => '2074.pm',
            AUTHOR        => 'Bob O\'Neill <bobo@cpan.org>',
        ) : ()
    ),
);
