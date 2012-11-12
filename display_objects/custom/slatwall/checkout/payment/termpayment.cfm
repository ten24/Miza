<!---

    Slatwall - An Open Source eCommerce Platform
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
<cfparam name="params.edit" type="boolean" default="true" />
<cfparam name="params.orderPayment" type="any" />
<cfparam name="params.orderPaymentIndex" type="string" />
<cfparam name="params.paymentMethod" type="any" />
<cfparam name="params.maximumAmount" type="numeric" />
<cfparam name="params.paymentTerm" type="any" />

<cfoutput>
	<div class="svocheckoutpaymenttermpayment">
		<input type="hidden" name="orderPayments[#params.orderPaymentIndex#].paymentMethod.paymentMethodID" value="#params.paymentMethod.getPaymentMethodID()#" />
		<input type="hidden" name="orderPayments[#params.orderPaymentIndex#].orderPaymentID" value="#params.orderPayment.getOrderPaymentID()#" />
		<input type="hidden" name="orderPayments[#params.orderPaymentIndex#].paymentTerm.paymentTermID" value="#params.paymentTerm.getPaymentTermID()#" />
		<input type="hidden" name="orderPayments[#params.orderPaymentIndex#].termPaymentAccount.accountID" value="#$.slatwall.cart('account').getAccountID()#" />
		<dl>
			<dt>Account Terms</dt>
			<dd>#params.paymentTerm.getPaymentTermName()#</dd>
			<dt>Account Credit Limit</dt>
			<dd>#$.slatwall.formatValue( $.slatwall.cart().getAccount().setting('accountTermCreditLimit'), "currency")#</dd>
			<dt>Unused Credit</dt>
			<dd>#$.slatwall.cart().getAccount().getFormattedValue('termAccountAvailableCredit')#</dd>
			<dt>Account Balance</dt>
			<dd>#$.slatwall.cart().getAccount().getFormattedValue('termAccountBalance')#</dd>
			<dt>Amount To Apply to Order</dt>
			<dd><input type="text" name="orderPayments[#params.orderPaymentIndex#].amount" value="#params.maximumAmount#" /></dd>
		</dl>
	</div>
</cfoutput>