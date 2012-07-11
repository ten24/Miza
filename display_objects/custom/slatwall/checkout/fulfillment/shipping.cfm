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
<cfparam name="params.orderFulfillment" type="any" />
<cfparam name="params.orderFulfillmentIndex" type="string" />
<cfparam name="params.edit" type="boolean" />

<cfset local.address = $.slatwall.getService("addressService").newAddress() />

<!--- If a Shipping Address for this fulfillment is specified, then use it --->
<cfif not isNull(params.orderFulfillment.getShippingAddress())>
	<cfset local.selectedAccountAddressID = "" />
	<!--- override the new local.address with whatever the shipping address is --->
	<cfset local.address = params.orderFulfillment.getShippingAddress() />
<!--- If an Account Shipping Address for this fulfillment is specified, then use it --->
<cfelseif not isNull(params.orderFulfillment.getAccountAddress())>
	<cfset local.selectedAccountAddressID = params.orderFulfillment.getAccountAddress().getAccountAddressID() />
	<!--- If we are not in edit mode then override the local.address with the account address --->
	<cfif not params.edit>
		<cfset local.address = params.orderFulfillment.getAccountAddress().getAddress() />
	</cfif>
<!--- If the fulfillment has nothing, But this account has addresses the set the current as an account address --->
<cfelseif arrayLen($.slatwall.account().getAccountAddresses())>
	<cfset local.selectedAccountAddressID = $.slatwall.account().getAccountAddresses()[1].getAccountAddressID() /> <!--- Todo: change to primary address --->
<!--- Defualt case for new customers with nothing setup --->
<cfelse>
	<cfset local.selectedAccountAddressID = "" />
</cfif>

<cfoutput>
	<div class="svocheckoutfulfillmentshipping">
		<div class="shippingAddress">
			<h4>Shipping Address</h4>
			
			<!--- If In Edit Mode, show the different Shipping Address Form Fields --->
			<cfif params.edit>
				
				<!--- Check For Account Address Options, Loop over and create the various form fields for each --->
				<cfif arrayLen($.slatwall.account().getAccountAddresses())>
					<dl>
						<dt><label for="orderFulfillments[#params.orderFulfillmentIndex#].addressIndex">Select an Address</label></dt>
						<dd>
							<select name="orderFulfillments[#params.orderFulfillmentIndex#].addressIndex">
								<option value="0">New Address</option>
								<cfloop from="1" to="#arrayLen($.slatwall.account().getAccountAddresses())#" index="local.addressIndex">
									<cfset local.accountAddress = $.slatwall.account().getAccountAddresses()[local.addressIndex] />
									<option value="#local.addressIndex#" <cfif local.selectedAccountAddressID EQ local.accountAddress.getAccountAddressID()>Selected</cfif>>#local.accountAddress.getAccountAddressName()#</option>
								</cfloop>
							</select>
						</dd>
					</dl>
					<cfloop from="1" to="#arrayLen($.slatwall.account().getAccountAddresses())#" index="local.addressIndex">
						<cfset local.accountAddress = request.slatwallScope.account().getAccountAddresses()[local.addressIndex] />
						<div id="shippingAddress_#local.addressIndex#" class="addressBlock" style="display:none;">
							<!--- Uncomment if you want to be able to rename address nicknames during checkout --->
							<!---
							<dl>
								<dt><label for="orderFulfillments[#params.orderFulfillmentIndex#].accountAddresses[#local.addressIndex#].accountAddressName">Address Nickname</label></dt>
								<dd><input type="text" name="orderFulfillments[#params.orderFulfillmentIndex#].accountAddresses[#local.addressIndex#].accountAddressName" value="#local.accountAddress.getAccountAddressName()#" /></dd>	
							</dl>
							--->
							<cf_SlatwallAddressDisplay address="#local.accountAddress.getAddress()#" fieldNamePrefix="orderFulfillments[#params.orderFulfillmentIndex#].accountAddresses[#local.addressIndex#].address." edit="true">
							<input type="hidden" name="orderFulfillments[#params.orderFulfillmentIndex#].accountAddresses[#local.addressIndex#].accountAddressID" value="#local.accountAddress.getAccountAddressID()#" />
						</div>
					</cfloop>
				</cfif>
				
				<!--- New Address Form --->
				<div id="shippingAddress_0" class="addressBlock" style="display:none;">
					<cf_SlatwallAddressDisplay address="#local.address#" fieldNamePrefix="orderFulfillments[#params.orderFulfillmentIndex#].shippingAddress." edit="#params.edit#">
					
					<!--- Save New Address Option (Only if not a guest account) --->
					<cfif not $.slatwall.account().isGuestAccount()>
						<dl>
							<dt><label for="orderFulfillments[#params.orderFulfillmentIndex#].saveAccountAddress">Save This Address</label></dt>
							<dd>
								<input type="hidden" name="orderFulfillments[#params.orderFulfillmentIndex#].saveAccountAddress" value="" />
								<input type="checkbox" name="orderFulfillments[#params.orderFulfillmentIndex#].saveAccountAddress" value="1" />
							</dd>
						</dl>
						<dl style="display:none;" class="accountAddressName">
							<dt><label for="orderFulfillments[#params.orderFulfillmentIndex#].saveAccountAddressName">Address Nickname</label></dt>
							<dd>
								<input type="text" name="orderFulfillments[#params.orderFulfillmentIndex#].saveAccountAddressName" value="" />
							</dd>
						</dl>
					</cfif>
				</div>
				
				<input type="hidden" name="orderFulfillments[#params.orderFulfillmentIndex#].orderFulfillmentID" value="#params.orderFulfillment.getOrderFulfillmentID()#" />

			<!--- If NOT In Edit Mode, just display the address --->
			<cfelse>
				<cf_SlatwallAddressDisplay address="#local.address#" edit="false">
			</cfif>
		</div>
		
		<cfif arrayLen(params.orderFulfillment.getShippingMethodOptions())>
			<div class="shippingMethod">
				<h4>Shipping Method</h4>
				<cf_SlatwallShippingMethodDisplay orderFulfillmentIndex="#params.orderFulfillmentIndex#" orderFulfillmentShipping="#params.orderFulfillment#" edit="#local.edit#">
			</div>
		</cfif>
	</div>
	
	<script type="text/javascript">
		jQuery(document).ready(function(){
			jQuery('.addressBlock').hide();
			jQuery('select[name="orderFulfillments[#params.orderFulfillmentIndex#].addressIndex"]').change(function(){
				jQuery('.addressBlock').hide();
				var selectedAddressIndex = jQuery('select[name="orderFulfillments[#params.orderFulfillmentIndex#].addressIndex"]').val();
				if(selectedAddressIndex == 0){
					jQuery('##shippingAddress').show();
				} else {
					jQuery('##accountAddress_'+selectedAddressIndex).show();
				}
			});
			<cfif Not arrayLen($.slatwall.account().getAccountAddresses())>
				jQuery('##shippingAddress').show();
			<cfelse>
				jQuery('select[name="orderFulfillments[#params.orderFulfillmentIndex#].addressIndex"]').change();
			</cfif>
		});
	</script>
</cfoutput>
