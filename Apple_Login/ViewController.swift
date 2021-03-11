//
//  ViewController.swift
//  Apple_Login
//
//  Created by 이상훈 on 2021/03/05.
//

import UIKit
import AuthenticationServices //애플 로그인 필수 프레임워크

class ViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @IBOutlet var loginProviderStackView: UIStackView!
    @IBOutlet var lblLoginID: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProviderLoginView() //View에 "Sign In with Apple" 버튼 보이기
        
    }
    
    func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)

        self.loginProviderStackView.addArrangedSubview (authorizationButton)
        
    } // 프레임워크에서 제공하는 "Sign In with Apple" 타입과 스타일
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        let appleIdRequest = ASAuthorizationAppleIDProvider().createRequest()
        appleIdRequest.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [appleIdRequest])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    } // "Sign In with Apple" 버튼 클릭 시
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }//Apple 로그인 화면을 모달 시트로 표시하는 함수
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        //Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            lblLoginID.text = userIdentifier
            lblName.text = fullName?.givenName
            lblEmail.text = email
            
            
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? "")) ")
        default:
            break
        }
    } //Apple ID 연동 성공 시
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("로그인 실패")
        
    }//Apple ID 연동 실패 시
    
}

