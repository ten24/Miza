<!---

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfparam name="rc.edit" type="string" default="" />
<cfparam name="rc.orderRequirementsList" type="string" default="" />
<cfparam name="rc.account" type="any" />
 

<!--- Mura Variables --->
<cfparam name="request.status" default="">
<cfparam name="request.isBlocked" default="false">

<cfoutput>
	<div class="svocheckoutaccount">
		<div id="checkoutAccountContent" class="contentBlock">
			<cfif listFind(rc.orderRequirementsList, 'account') || rc.edit eq "account">
				<cfif listFind(rc.orderRequirementsList, 'account')>
					<cfset $.event('loginSlatAction', 'frontend:checkout.loginAccount') />
					#view("account/login")#
				</cfif>
				<cfif rc.edit neq "account">
					<div class="accountDetails">
				<cfelse>
					<div class="accountEdit">
				</cfif>
					<form name="account" method="post" action="?slatAction=frontend:checkout.saveorderaccount">
						<input type="hidden" name="siteID" value="#$.event('siteID')#" />
						<input type="hidden" name="account.accountID" value="#rc.account.getAccountID()#" />
						<cfif rc.edit eq "account"><h4>Edit Account Details</h4><cfelse><h4>New Customer</h4></cfif>
						<dl>
							<cf_SlatwallPropertyDisplay object="#rc.account#" fieldname="account.firstName" property="firstName" edit="true">
							<cf_SlatwallPropertyDisplay object="#rc.account#" fieldname="account.lastName" property="lastName" edit="true">
							<dt class="spdemailaddress">
								<label for="account.emailAddress" class="required">#$.slatwall.rbKey('entity.accountEmailAddress.emailAddress')#</label>
							</dt>
							<dd id="spdemailaddress">
								<cfset emailValue = "" />
								<cfif not isNull(rc.account.getPrimaryEmailAddress()) and not isNull(rc.account.getPrimaryEmailAddress().getEmailAddress())>
									<cfset emailValue = rc.account.getPrimaryEmailAddress().getEmailAddress() />	
								</cfif>
								<input type="text" name="account.emailAddress" value="#emailValue#" />
								<cfif len(rc.account.getErrorBean().getError("primaryEmailAddress"))>
									<span class="formError">#rc.account.getErrorBean().getError("primaryEmailAddress")#</span>
								</cfif>
							</dd>
							<dt class="spdphonenumber">
								<label for="account.phoneNumber" class="required">#$.slatwall.rbKey('entity.accountPhoneNumber.phoneNumber')#</label>
							</dt>
							<dd id="spdphonenumber">
								<cfset phoneValue = "" />
								<cfif not isNull(rc.account.getPrimaryPhoneNumber()) and not isNull(rc.account.getPrimaryPhoneNumber().getPhoneNumber())>
									<cfset phoneValue = rc.account.getPrimaryPhoneNumber().getPhoneNumber() />	
								</cfif>
								<input type="text" name="account.phoneNumber" value="#phoneValue#" />
								<cfif len(rc.account.getErrorBean().getError("primaryPhoneNumber"))>
									<span class="formError">#rc.account.getErrorBean().getError("primaryPhoneNumber")#</span>
								</cfif>
							</dd>
							<cfif rc.account.isGuestAccount()>
								<dt class="spdguestcheckout">
									<label for="account.createMuraAccount">#$.slatwall.rbKey('frontend.checkout.detail.guestcheckout')#</label>
								</dt>
								<dd id="spdguestcheckout">
									<input type="radio" name="account.guestAccount" value="1" />#$.slatwall.rbKey('frontend.checkout.detail.checkoutAsGuest')#<br />
									<input type="radio" name="account.guestAccount" value="0" checked="checked" />#$.slatwall.rbKey('frontend.checkout.detail.saveAccount')#<br />
								</dd>
								<dt class="spdpassword guestHide">
									<label for="account.password">Password</label>
								</dt>
								<dd id="spdpassword" class="guestHide">
									<input type="password" name="account.password" value="" />
									<cfif len(rc.account.getErrorBean().getError("password"))>
										<span class="formError">#rc.account.getErrorBean().getError("password")#</span>
									</cfif>
								</dd>
							</cfif>
						</dl>
						<button type="submit">Save & Continue</button><cfif not rc.account.isGuestAccount()><a href="?doaction=logout">Logout</a></cfif>
					</form>
				</div>
			</cfif>
		</div>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				jQuery("input[name='account.guestAccount']").change(function(){
					if(jQuery("input[name='account.guestAccount']:checked").val() == 0) {
						jQuery(".guestHide").show();
					} else {
						jQuery(".guestHide").hide();
					}
				});
			});
		</script>
	</div>
</cfoutput>