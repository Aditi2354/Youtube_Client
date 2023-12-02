//
//  AuthViewModel.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

protocol AuthViewModel: AnyObject {
    func signInWithGoogle(presentFrom presenter: Presentable) async throws
}
