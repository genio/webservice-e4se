use 5.010001;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'WebService::E4SE',
    AUTHOR           => q{Chase Whitener <cwhitener@gmail.com>},
    VERSION_FROM     => 'lib/WebService/E4SE.pm',
    ABSTRACT_FROM    => 'lib/WebService/E4SE.pm',
    LICENSE          => 'artistic_2',
    META_MERGE   => {
        dynamic_config => 0,
        'meta-spec' => {version => 2},
        prereqs => {runtime => {requires => {perl => '5.010001'}}},
        resources => {
            bugtracker  => {web =>'http://github.com/genio/webservice-e4se/issues'},
            homepage    => 'http://github.com/genio/webservice-e4se',
            license     => ['http://www.opensource.org/licenses/artistic-license-2.0'],
            repository  => {
                type => 'git',
                url => 'http://github.com/genio/webservice-e4se.git',
                web => 'http://github.com/genio/webservice-e4se',
            },
        },
        no_index => {directory => ['t']}
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
        'Test::Pod' => 0,
        'Test::Pod::Coverage' => 0,
        'Test::LWP::UserAgent' => 0,
    },
    PREREQ_PM => {
        'XML::Compile::SOAP' => 3.12,
        'XML::Compile::SOAP11' => 3.12,
        'XML::Compile::SOAP12' => 3.03,
        'XML::Compile::WSDL11' => 3.03,
        'XML::LibXML' => 2.0,
        'Authen::NTLM' => 1.0,
        'HTTP::Headers' => 6.0,
        'HTTP::Request' => 6.0,
        'File::Slurper' => 0,
        'LWP::UserAgent' => 6.0,
        'Moo' => 2.0,
        'strictures' => 2.0,
        'Try::Tiny' => 0,
        'URI' => 1.6,
        'namespace::clean' => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'WebService-E4SE-*' },
    test => {TESTS => 't/*.t'},
);
