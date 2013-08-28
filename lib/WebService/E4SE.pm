package WebService::E4SE;

use 5.006;
use Moose;
use MooseX::Types::Moose qw/Bool HashRef/;
use Carp;
use URI 1.60;
use LWP::UserAgent 6.02;
use HTTP::Headers;
use HTTP::Request;
use Authen::NTLM;
use Try::Tiny;
use XML::LibXML::Simple;
use XML::Compile::WSDL11;
use XML::Compile::SOAP11;
use XML::Compile::Transport::SOAPHTTP;
use namespace::autoclean;

=head1 NAME

WebService::E4SE - Communicate with the various Epicor E4SE web services.

=head1 VERSION

Version 0.01

=cut

our $AUTHORITY = 'cpan:CAPOEIRAB';
our $VERSION = '0.01';

has useragent => (
	is => 'ro',
	isa => 'LWP::UserAgent',
	required => 1,
	default => sub {
		my $lwp = LWP::UserAgent->new( keep_alive=>1 )
	}
);

has timeout => (
	is => 'rw',
	isa => 'Int',
	required => 1,
	default => 30,
);

has username => (
	is => 'rw',
	isa => 'Str',
	required => 1,
	default => '',
);

has password => (
	is => 'rw',
	isa => 'Maybe[Str]',
	required => 1,
	default => '',
);

has realm => (
	is => 'rw',
	isa => 'Maybe[Str]',
	required => 1,
	default => '',
);

has site => (
	is => 'rw',
	isa => 'Maybe[Str]',
	required => 1,
	default => 'epicor:80',
);

has base_url => (
	is => 'rw',
	isa => 'URI',
	required => 1,
	default => sub {
		URI->new('http://epicor/e4se')
	}
);

has wsdl => (
	is => 'rw',
	isa => 'HashRef[XML::Compile::WSDL11]',
	required => 0,
	default => sub { {} },
);

has files => (
	is => 'ro',
	isa => 'ArrayRef[Str]',
	required => 1,
	default => sub {[
		'ActionCall.asmx',
		'BackOfficeAP.asmx',
		'BackOfficeAR.asmx',
		'BackOfficeCFG.asmx',
		'BackOfficeGB.asmx',
		'BackOfficeGL.asmx',
		'BackOfficeIV.asmx',
		'BackOfficeMC.asmx',
		'Billing.asmx',
		'Business.asmx',
		'Carrier.asmx',
		'CommercialTerms.asmx',
		'Company.asmx',
		'ControllingProject.asmx',
		'CostVersion.asmx',
		'CRMClientHelper.asmx',
		'Currency.asmx',
		'Customer.asmx',
		'ECSClientHelper.asmx',
		'Employee.asmx',
		'ExchangeInterface.asmx',
		'Expense.asmx',
		'FinancialsAP.asmx',
		'FinancialsAR.asmx',
		'FinancialsCFG.asmx',
		'FinancialsGB.asmx',
		'FinancialsGL.asmx',
		'FinancialsMC.asmx',
		'FinancialsSync.asmx',
		'GLAccount.asmx',
		'IntersiteOrder.asmx',
		'InventoryLocation.asmx',
		'Journal.asmx',
		'Location.asmx',
		'LotSerial.asmx',
		'Manufacturer.asmx',
		'Material.asmx',
		'MaterialPlan.asmx',
		'MiscItems.asmx',
		'MSProject.asmx',
		'MSProjectEnterpriseCustomFieldsandLookupTables.asmx',
		'Opportunity.asmx',
		'Organization.asmx',
		'PartMaster.asmx',
		'Partner.asmx',
		'PriceStructure.asmx',
		'Project.asmx',
		'Prospect.asmx',
		'PSAClientHelper.asmx',
		'PurchaseOrder.asmx',
		'Receiving.asmx',
		'Recognize.asmx',
		'Resource.asmx',
		'SalesCycleManagement.asmx',
		'SalesOrder.asmx',
		'SalesPerson.asmx',
		'Shipping.asmx',
		'Site.asmx',
		'Supplier.asmx',
		'svActionCall.asmx',
		'svBackOfficeAP.asmx',
		'svBackOfficeAR.asmx',
		'svBackOfficeCFG.asmx',
		'svBackOfficeGB.asmx',
		'svBackOfficeGL.asmx',
		'svBackOfficeIV.asmx',
		'svBackOfficeMC.asmx',
		'svBilling.asmx',
		'svBusiness.asmx',
		'svCarrier.asmx',
		'svCommercialTerms.asmx',
		'svCompany.asmx',
		'svControllingProject.asmx',
		'svCostVersion.asmx',
		'svCRMClientHelper.asmx',
		'svCurrency.asmx',
		'svCustomer.asmx',
		'svECSClientHelper.asmx',
		'svEmployee.asmx',
		'svExchangeInterface.asmx',
		'svExpense.asmx',
		'svFinancialsAP.asmx',
		'svFinancialsAR.asmx',
		'svFinancialsCFG.asmx',
		'svFinancialsGB.asmx',
		'svFinancialsGL.asmx',
		'svFinancialsMC.asmx',
		'svFinancialsSync.asmx',
		'svGLAccount.asmx',
		'svIntersiteOrder.asmx',
		'svInventoryLocation.asmx',
		'svJournal.asmx',
		'svLocation.asmx',
		'svLotSerial.asmx',
		'svManufacturer.asmx',
		'svMaterial.asmx',
		'svMaterialPlan.asmx',
		'svMiscItems.asmx',
		'svMSProject.asmx',
		'svMSProjectEnterpriseCustomFieldsandLookupTables.asmx',
		'svOpportunity.asmx',
		'svOrganization.asmx',
		'svPartMaster.asmx',
		'svPartner.asmx',
		'svPriceStructure.asmx',
		'svProject.asmx',
		'svProspect.asmx',
		'svPSAClientHelper.asmx',
		'svPurchaseOrder.asmx',
		'svReceiving.asmx',
		'svRecognize.asmx',
		'svResource.asmx',
		'svSalesCycleManagement.asmx',
		'svSalesOrder.asmx',
		'svSalesPerson.asmx',
		'svShipping.asmx',
		'svSite.asmx',
		'svSupplier.asmx',
		'svSysArtifact.asmx',
		'svSysDirector.asmx',
		'svSysDomainInfo.asmx',
		'svSysNotify.asmx',
		'svSysSearchManager.asmx',
		'svSysSecurity.asmx',
		'svSysWorkflow.asmx',
		'svTax.asmx',
		'svTime.asmx',
		'svUOM.asmx',
		'SysArtifact.asmx',
		'SysDirector.asmx',
		'SysDomainInfo.asmx',
		'SysNotify.asmx',
		'SysSearchManager.asmx',
		'SysSecurity.asmx',
		'SysWorkflow.asmx',
		'Tax.asmx',
		'Time.asmx',
		'UOM.asmx',
	]},
);

sub _wsdl {
	my ( $self, $file ) = @_;
	my $wsdl = $self->wsdl;
	$self->useragent->credentials( $self->site, $self->realm, $self->username, $self->password );
	$self->useragent->timeout($self->timeout);
	try {
		my $res = $self->useragent->get($self->base_url . '/'. $file . '?WSDL' );
		unless ( $res->is_success ) {
			confess( "Unable to grab WSDL: ".$res->status_line );
			return 0;
		}
		$wsdl->{$file} = XML::Compile::WSDL11->new( $res->decoded_content );
		return 1;
	}
	catch {
		warn "Error communicating with: ".$self->base_url . '/'. $file . '?WSDL: '. $_;
		return 0;
	}
}

sub _valid_file {
	my ( $self, $file ) = @_;
	return 0 unless defined $file and length $file;
	if (grep {$_ eq $file} @{$self->files}) {
		return 1;
	}
	return 0;
}

=head1 SYNOPSIS

Once you have Epicor's E4SE software installed, you're stuck in a clunky
world of Windows and IE-only ugliness.  Why not make the world a better
place and use their web services to make a nicer interface?

	use WebService::E4SE;

	my $ws = WebService::E4SE->new(
		username => 'AD\username',			# NTLM authentication
		password => 'A password',			# NTLM authentication
		realm => '',						# LWP::UserAgent and Authen::NTLM
		site => 'epicor:80',				# LWP::UserAgent and Authen::NTLM
		base_url => 'http://epicor/e4se',	# LWP::UserAgent and Authen::NTLM
		timeout => 30, 						# LWP::UserAgent
	);
	my $res = $ws->files(); # returns an array ref of web service APIs to communicate with
	say Dumper $res;
	...
	my $res = $ws->call('Resource.asmx','list_calls'); # returns a list of XML::Compile::SOAP::Operation objects
	...
	my $res = $ws->call('Resource.asmx','GetResourceForUserID',0,userID=>'someuser');
	unless( $res ) {
		Carp::confess( "Couldn't get user id" );
		exit();
	}
	say Dumper $res;


=head1 METHODS

=head2 call

=cut

sub call {
	my ( $self, $file, $function, $force_wsdl, %parameters ) = @_;
	unless ( $self->_valid_file($file) ) {
		warn "$file is not a valid web service found in E4SE.";
		return 0;
	}

	my $port = $file;
	$port =~ s/\.asmx$/WSSoap/;
	my $wsdl = $self->wsdl;
	if ( !exists($wsdl->{$file}) or !defined($wsdl->{$file}) or $force_wsdl ) {
		return 0 unless ( $self->_wsdl( $file ) );
		my $trans = XML::Compile::Transport::SOAPHTTP->new(
			user_agent=> $self->useragent,
			address => $self->base_url.'/'. $file,
		);
		$wsdl->{$file}->compileCalls(
			port => $port,
			transport => $trans,
		);
	}

	if ( $function eq 'list_calls' ) {
		return $wsdl->{$file}->operations(port=>$port);
	}
	
	#return $call;
	try {
		my ($res,$trace) = $wsdl->{$file}->call(
			$function,
			%parameters
		);
		if ( $trace->error() ) {
			warn "Error running $file :: $function: ".$trace->error();
			return 0;
		}

		my $xml = XML::LibXML::Simple::XMLin($trace->response()->content());
		if ( exists( $xml->{'soap:Body'}->{'soap:Fault'}) ) {
			warn "Error encountered: ".$xml->{'soap:Body'}->{'soap:Fault'}->{faultstring};
			return 0;
		}
		return $xml unless defined($xml->{'soap:Body'});
		return $xml->{'soap:Body'} unless defined($xml->{'soap:Body'}->{$function.'Response'});
		return $xml->{'soap:Body'}->{$function.'Response'} unless defined($xml->{'soap:Body'}->{$function.'Response'}->{$function.'Result'});
		return $xml->{'soap:Body'}->{$function.'Response'}->{$function.'Result'};
	}
	catch {
		warn "Error communicating with server: $_";
		return 0;
	}
}

=head1 AUTHOR

Chase Whitener << <cwhitener at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-webservice-e4se at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WebService-E4SE>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

	perldoc WebService::E4SE


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WebService-E4SE>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WebService-E4SE>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WebService-E4SE>

=item * Search CPAN

L<http://search.cpan.org/dist/WebService-E4SE/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Chase Whitener.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of WebService::E4SE
