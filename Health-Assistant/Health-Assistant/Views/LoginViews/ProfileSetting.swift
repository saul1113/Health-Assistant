//
//  ProfileSetting.swift
//  Health-Assistant
//
//  Created by 강희창 on 11/4/24.
//

import SwiftUI

enum Gender: String, CaseIterable {
    case male = "남자"
    case female = "여자"
    case other = "기타"
}

enum BloodType: String, CaseIterable {
    case aPlus = "Rh+ A"
    case aMinus = "Rh- A"
    case bPlus = "Rh+ B"
    case bMinus = "Rh- B"
    case abPlus = "Rh+ AB"
    case abMinus = "Rh- AB"
    case oPlus = "Rh+ O"
    case oMinus = "Rh- O"
}

struct ProfileSetting: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var dataManager: DataManager
    
    @State private var name: String = ""
    @State private var nickname: String = ""
    @State private var birthday: String = ""
    @State private var nicknameError: String?
    @State private var birthdayError: String?
    @State private var isNicknameAvailable: Bool? // nil: 없음, true: 사용 가능, false: 중복
    @State private var selectedGender: Gender? = nil
    @State private var selectedBloodType: BloodType = .aPlus
    @State private var showImagePicker = false
    @State private var profileImage: UIImage? = UIImage(named: "HAHALogo")
    @State private var navigateToHealthAllowView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ProfileImageView(profileImage: $profileImage, showImagePicker: $showImagePicker)
                
                VStack(alignment: .leading) {
                    Text("이름")
                        .font(Font.semibold20)
                    TextFieldView(text: $name, placeholder: "실명을 입력해주세요.")
                }
                .padding(.leading, 40)
                .padding(.trailing, 40)
                
                VStack(alignment: .leading) {
                    Text("닉네임")
                        .font(Font.semibold20)
                    HStack {
                        TextFieldView(
                            text: $nickname,
                            placeholder: "2자 - 10자 사이로 입력하세요.",
                            showError: nicknameError != nil,
                            errorColor: .red,
                            onTextChange: { newValue in
                                validateNickname(newValue)
                            }
                        )
                        Button("중복확인") {
                            checkNicknameAvailability()
                        }
                        .padding(6)
                        .foregroundStyle(.white)
                        .font(Font.bold16)
                        .background(Color.customGreen)
                        .cornerRadius(8)
                    }
                    if let error = nicknameError {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    } else if isNicknameAvailable == true {
                        Text("사용 가능한 닉네임입니다")
                            .foregroundColor(.blue)
                            .font(.caption)
                    } else if isNicknameAvailable == false {
                        Text("이미 존재하는 닉네임입니다")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding([.leading, .trailing], 40)
                .padding(.top, 30)
                
                VStack(alignment: .leading) {
                    Text("생년월일")
                        .font(Font.semibold20)
                    TextFieldView(
                        text: $birthday,
                        placeholder: "숫자 8자리로 입력해주세요.",
                        showError: birthdayError != nil,
                        errorColor: .red,
                        onTextChange: { newValue in
                            validateBirthday(newValue)
                        }
                    )
                    
                    if let error = birthdayError {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding([.leading, .trailing], 40)
                .padding(.top, 30)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("성별")
                            .font(Font.semibold20)
                            .padding(.top, 10)
                        HStack(spacing: 15) {
                            ForEach(Gender.allCases, id: \.self) { gender in
                                Button(action: {
                                    selectedGender = gender
                                }) {
                                    Text(gender.rawValue)
                                        .font(Font.regular14)
                                        .foregroundColor(selectedGender == gender ? Color.CustomGreen : Color(uiColor: .systemGray))
                                        .frame(width: 50, height: 50)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(selectedGender == gender ? Color.CustomGreen : Color(uiColor: .systemGray), lineWidth: 2)
                                        )
                                }
                            }
                        }
                    }
                    .padding(.trailing, 18)
                    VStack {
                        Text("혈액형")
                            .font(Font.semibold20)
                        Picker("혈액형을 선택하세요.", selection: $selectedBloodType) {
                            ForEach(BloodType.allCases, id: \.self) { bloodType in
                                Text(bloodType.rawValue)
                                    .foregroundStyle(Color(uiColor: .systemGray))
                                    .font(Font.regular14)
                            }
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        }
                        .padding()
                    }
                    .padding(.top, 30)
                }
                Spacer()
                NavigationLink(destination: HealthAllowView()) {
                    Text("다 음")
                        .font(Font.semibold24)
                        .foregroundStyle(.white)
                        .frame(width: 330, height: 50)
                        .background(Color.CustomGreen)
                        .cornerRadius(8)
                        .padding(.bottom, 30)
                }
            }
            .navigationTitle("프로필 설정")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        BackButton()
                    }
                }
            }
        }
    }
    private func validateNickname(_ newValue: String) {
        if newValue.isEmpty {
            nicknameError = nil
            isNicknameAvailable = nil
        } else if newValue.count < 2 || newValue.count > 10 {
            nicknameError = "닉네임은 2글자 이상 10자 이내로 설정하여주세요."
            isNicknameAvailable = nil
        } else {
            nicknameError = nil
        }
    }
    
    private func validateBirthday(_ newValue: String) {
        if newValue.isEmpty {
            birthdayError = nil
        } else if newValue.count != 8 || Int(newValue) == nil {
            birthdayError = "생년월일은 숫자 8자리로 입력해주세요."
        } else {
            birthdayError = nil
        }
    }
    
    private func checkNicknameAvailability() {
        if nickname.isEmpty || nickname.count < 2 || nickname.count > 10 {
            nicknameError = "닉네임은 2글자 이상 10자 이내로 설정하여주세요."
            isNicknameAvailable = nil
        } else {
            if nickname == "중복닉네임" {
                isNicknameAvailable = false
            } else {
                isNicknameAvailable = true
            }
            nicknameError = nil
        }
    }
}

#Preview {
    ProfileSetting(dataManager: DataManager())
}
