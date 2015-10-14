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
            homepage    => 'http://cwhitener.com',
            license     => 'http://www.opensource.org/licenses/artistic-license-2.0',
            repository  => 'http://github.com/genio/webservice-e4se',
            bugtracker  => 'http://github.com/genio/webservice-e4se/issues'
        },
        no_index => {directory => ['t']}
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
        'Test::Pod' => 0,
        'Test::Pod::Coverage' => 0,
    },
    PREREQ_PM => {
        'XML::Compile::SOAP' => 2.38,
        'XML::Compile::WSDL11' => 2.38,
        'XML::LibXML' => 1.94,
        'Authen::NTLM' => 1.0,
        'HTTP::Headers' => 6.0,
        'HTTP::Request' => 6.0,
        'LWP::UserAgent' => 6.0,
        'Moo' => 2.0,
        'strictures' => 2.0,
        'URI' => 1.6,
        'namespace::clean' => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'WebService-E4SE-*' },
    test => {TESTS => 't/*.t'},
);
