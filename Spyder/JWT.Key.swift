//
//  JWT.Key.swift
//  Spyder
//
//  Copyright (c) 2016 Dima Bart
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those
//  of the authors and should not be interpreted as representing official policies,
//  either expressed or implied, of the FreeBSD Project.
//

import Foundation

extension JWT {
    enum Key: String {
        
        /// To support use cases in which the JWT content is secured by a means
        /// other than a signature and/or encryption contained within the JWT
        /// (such as a signature on a data structure containing the JWT), JWTs
        /// MAY also be created without a signature or encryption.  An Unsecured
        /// JWT is a JWS using the "alg" Header Parameter value "none" and with
        /// the empty string for its JWS Signature value, as defined in the JWA
        /// specification [JWA]; it is an Unsecured JWS with the JWT Claims Set
        /// as its JWS Payload.
        case alg
        
        /// The "cty" (content type) Header Parameter defined by [JWS] and [JWE]
        /// is used by this specification to convey structural information about
        /// the JWT.
        ///
        /// In the normal case in which nested signing or encryption operations
        /// are not employed, the use of this Header Parameter is NOT
        /// RECOMMENDED.  In the case that nested signing or encryption is
        /// employed, this Header Parameter MUST be present; in this case, the
        /// value MUST be "JWT", to indicate that a Nested JWT is carried in this
        /// JWT.  While media type names are not case sensitive, it is
        /// RECOMMENDED that "JWT" always be spelled using uppercase characters
        /// for compatibility with legacy implementations.  See Appendix A.2 for
        /// an example of a Nested JWT.
        case cty
        
        /// The "typ" (type) Header Parameter defined by [JWS] and [JWE] is used
        /// by JWT applications to declare the media type [IANA.MediaTypes] of
        /// this complete JWT.  This is intended for use by the JWT application
        /// when values that are not JWTs could also be present in an application
        /// data structure that can contain a JWT object; the application can use
        /// this value to disambiguate among the different kinds of objects that
        /// might be present.  It will typically not be used by applications when
        /// it is already known that the object is a JWT.  This parameter is
        /// ignored by JWT implementations; any processing of this parameter is
        /// performed by the JWT application.  If present, it is RECOMMENDED that
        /// its value be "JWT" to indicate that this object is a JWT.  While
        /// media type names are not case sensitive, it is RECOMMENDED that "JWT"
        /// always be spelled using uppercase characters for compatibility with
        /// legacy implementations.  Use of this Header Parameter is OPTIONAL.
        case typ
        
        /// The "iss" (issuer) claim identifies the principal that issued the
        /// JWT.  The processing of this claim is generally application specific.
        /// The "iss" value is a case-sensitive string containing a StringOrURI
        /// value.  Use of this claim is OPTIONAL.
        case iss
        
        /// The "sub" (subject) claim identifies the principal that is the
        /// subject of the JWT.  The claims in a JWT are normally statements
        /// about the subject.  The subject value MUST either be scoped to be
        /// locally unique in the context of the issuer or be globally unique.
        /// The processing of this claim is generally application specific.  The
        /// "sub" value is a case-sensitive string containing a StringOrURI
        /// value.  Use of this claim is OPTIONAL.
        case sub
        
        /// The "aud" (audience) claim identifies the recipients that the JWT is
        /// intended for.  Each principal intended to process the JWT MUST
        /// identify itself with a value in the audience claim.  If the principal
        /// processing the claim does not identify itself with a value in the
        /// "aud" claim when this claim is present, then the JWT MUST be
        /// rejected.  In the general case, the "aud" value is an array of case-
        /// sensitive strings, each containing a StringOrURI value.  In the
        /// special case when the JWT has one audience, the "aud" value MAY be a
        /// single case-sensitive string containing a StringOrURI value.  The
        /// interpretation of audience values is generally application specific.
        /// Use of this claim is OPTIONAL.
        case aud
        
        /// The "exp" (expiration time) claim identifies the expiration time on
        /// or after which the JWT MUST NOT be accepted for processing.  The
        /// processing of the "exp" claim requires that the current date/time
        /// MUST be before the expiration date/time listed in the "exp" claim.
        /// Implementers MAY provide for some small leeway, usually no more than
        /// a few minutes, to account for clock skew.  Its value MUST be a number
        /// containing a NumericDate value.  Use of this claim is OPTIONAL.
        case exp
        
        /// The "nbf" (not before) claim identifies the time before which the JWT
        /// MUST NOT be accepted for processing.  The processing of the "nbf"
        /// claim requires that the current date/time MUST be after or equal to
        /// the not-before date/time listed in the "nbf" claim.  Implementers MAY
        /// provide for some small leeway, usually no more than a few minutes, to
        /// account for clock skew.  Its value MUST be a number containing a
        /// NumericDate value.  Use of this claim is OPTIONAL.
        case nbf
        
        /// The "iat" (issued at) claim identifies the time at which the JWT was
        /// issued.  This claim can be used to determine the age of the JWT.  Its
        /// value MUST be a number containing a NumericDate value.  Use of this
        /// claim is OPTIONAL.
        case iat
        
        /// The "jti" (JWT ID) claim provides a unique identifier for the JWT.
        /// The identifier value MUST be assigned in a manner that ensures that
        /// there is a negligible probability that the same value will be
        /// accidentally assigned to a different data object; if the application
        /// uses multiple issuers, collisions MUST be prevented among values
        /// produced by different issuers as well.  The "jti" claim can be used
        /// to prevent the JWT from being replayed.  The "jti" value is a case-
        /// sensitive string.  Use of this claim is OPTIONAL.
        case jti
    }
}
