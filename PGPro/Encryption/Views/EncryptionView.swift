//
//  EncryptionView.swift
//  PGPro
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

import SwiftUI

struct EncryptionView: View {
    @StateObject private var viewModel = EncryptionViewModel()

    @FocusState private var presentingKeyboard: Bool

    @State private var presentingPassphraseInput: Bool = false

    private struct HeaderView: View {
        var title: String

        var body: some View {
            Text(title)
                .font(Font.system(.body).smallCaps())
                .foregroundColor(Color.secondary)

            Divider()
                .padding(.bottom, 8)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Recipients
                VStack(alignment: .leading, spacing: 0) {
                    HeaderView(title: "Recipients")

                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(Array(viewModel.recipients)) { contact in
                                UserAvatarView(name: contact.name)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            viewModel.recipients.remove(contact)
                                        } label: {
                                            Label("Remove Recipient", systemImage: "person.badge.minus")
                                        }
                                    } preview: {
                                        HStack(alignment: .center) {
                                            UserAvatarView(name: contact.name)
                                            VStack(alignment: .leading) {
                                                Text(contact.name)
                                                Text(contact.email)
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .padding()
                                    }
                            }

                            NavigationLink {
                                KeyPickerView(withTitle: "Select Recipients", type: .publicKeys, selection: $viewModel.recipients)
                            } label: {
                                ZStack {
                                    Circle()
                                        .strokeBorder(Color.accentColor, lineWidth: 2)
                                        .frame(width: 40.0, height: 40.0, alignment: .center)

                                    Image(systemName: "plus")
                                        .font(.system(.body, design: .rounded, weight: .bold))
                                        .foregroundColor(Color.accentColor)
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }

                // Message
                VStack(alignment: .leading, spacing: 0) {
                    HeaderView(title: "Message")

                    TextEditor(text: $viewModel.message)
                        .multilineTextAlignment(.leading)
                        .scrollContentBackground(.hidden)
                        .foregroundColor(viewModel.message == viewModel.placeholder ? .gray : .primary)
                        .onTapGesture {
                            if viewModel.message == viewModel.placeholder {
                                viewModel.message = ""
                            }
                        }
                        .focused($presentingKeyboard)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()

                                Button(role: .cancel) {
                                    presentingKeyboard = false
                                } label: {
                                    Image(systemName: "keyboard.chevron.compact.down")
                                }
                            }
                        }
                }

                // Signatures
                VStack(alignment: .leading, spacing: 0) {
                    HeaderView(title: "Signatures")

                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(Array(viewModel.signers)) { contact in
                                ZStack {
                                    RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                                        .fill(Color.accentColor)
                                        .frame(maxHeight: 40.0)

                                    VStack(alignment: .leading) {
                                        Text(verbatim: contact.name)
                                            .font(.caption)
                                            .bold()
                                            .foregroundColor(.white)
                                        Text(verbatim: contact.email)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal)
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        viewModel.signers.remove(contact)
                                    } label: {
                                        Label("Remove Signature", systemImage: "person.badge.minus")
                                    }
                                } preview: {
                                    HStack(alignment: .center) {
                                        UserAvatarView(name: contact.name)
                                        VStack(alignment: .leading) {
                                            Text(contact.name)
                                            Text(contact.email)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding()
                                }
                            }

                            NavigationLink {
                                KeyPickerView(withTitle: "Select Signing Keys", type: .privateKeys, selection: $viewModel.signers)
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                                        .strokeBorder(Color.accentColor, lineWidth: 2)
                                        .frame(width: 40.0, height: 40.0, alignment: .center)

                                    Image(systemName: "plus")
                                        .font(.system(.body, design: .rounded, weight: .bold))
                                        .foregroundColor(Color.accentColor)
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }

                Divider()

                Button(action: {
                    // Ask for passphrases if required
                    presentingPassphraseInput = viewModel.passphraseInputRequired
                    Log.d("viewModel.signers.filter({ $0.requiresPassphrase }).count = \(viewModel.signers.filter({ $0.requiresPassphrase }).count)")
                    Log.d("viewModel.passphraseForKey.count = \(viewModel.passphraseForKey.count)")
                    // TODO: Call OpenPGP.encrypt(...) and present result
                    print("Encrypt...")
                }, label: {
                    Text("Encrypt")
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.vertical)
                .disabled(!viewModel.readyForEncryption)
                .sheet(isPresented: $presentingPassphraseInput) {
                    PassphraseInputView(contacts: viewModel.signers.filter({ $0.requiresPassphrase }), passphraseForKey: $viewModel.passphraseForKey)
                }
            }
            .padding()
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Encryption")
            .ignoresSafeArea(.keyboard)
        }
    }
}

struct EncryptionView_Previews: PreviewProvider {
    static var previews: some View {
        EncryptionView()
    }
}