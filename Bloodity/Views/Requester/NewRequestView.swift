import SwiftUI

struct NewRequestView: View {
    @Bindable var viewModel: RequesterViewModel
    @Binding var isPresented: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                Color.deepNavy.ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: BSpacing.xxl) {
                        // Header
                        VStack(spacing: BSpacing.sm) {
                            Image(systemName: "drop.fill")
                                .font(.system(size: 36))
                                .foregroundStyle(LinearGradient.bloodGradient)

                            Text("New Blood Request")
                                .font(BFont.title())
                                .foregroundColor(.textPrimary)

                            Text("Fill in the details to find compatible donors")
                                .font(BFont.body())
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.top, BSpacing.xl)

                        // Form
                        VStack(spacing: BSpacing.lg) {
                            // Patient Name
                            formField(label: "Patient Name", icon: "person.fill") {
                                TextField("", text: $viewModel.newPatientName, prompt: Text("Enter patient name").foregroundColor(.textSecondary.opacity(0.5)))
                                    .foregroundColor(.textPrimary)
                            }

                            // Blood Type
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Blood Type Needed")
                                    .font(BFont.captionBold())
                                    .foregroundColor(.textSecondary)

                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                                    ForEach(BloodType.allCases) { type in
                                        Button {
                                            withAnimation(.spring(response: 0.3)) {
                                                viewModel.newBloodType = type
                                            }
                                        } label: {
                                            Text(type.rawValue)
                                                .font(BFont.headline(15))
                                                .foregroundColor(viewModel.newBloodType == type ? .white : .textSecondary)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 44)
                                                .background(
                                                    RoundedRectangle(cornerRadius: BRadius.sm)
                                                        .fill(viewModel.newBloodType == type ? type.color.gradient : Color.cardDark.gradient)
                                                )
                                        }
                                    }
                                }
                            }

                            // Urgency
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Urgency Level")
                                    .font(BFont.captionBold())
                                    .foregroundColor(.textSecondary)

                                HStack(spacing: 8) {
                                    ForEach(UrgencyLevel.allCases, id: \.rawValue) { level in
                                        Button {
                                            withAnimation(.spring(response: 0.3)) {
                                                viewModel.newUrgency = level
                                            }
                                        } label: {
                                            VStack(spacing: 4) {
                                                Image(systemName: level.icon)
                                                    .font(.system(size: 18))
                                                Text(level.rawValue)
                                                    .font(BFont.captionBold())
                                            }
                                            .foregroundColor(viewModel.newUrgency == level ? .white : .textSecondary)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 60)
                                            .background(
                                                RoundedRectangle(cornerRadius: BRadius.md)
                                                    .fill(viewModel.newUrgency == level ? level.color.gradient : Color.cardDark.gradient)
                                            )
                                        }
                                    }
                                }
                            }

                            // Hospital
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Hospital")
                                    .font(BFont.captionBold())
                                    .foregroundColor(.textSecondary)

                                Menu {
                                    ForEach(MockData.hospitals) { hospital in
                                        Button(hospital.name) {
                                            viewModel.selectedHospital = hospital
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "building.2.fill")
                                            .foregroundColor(.textSecondary)
                                        Text(viewModel.selectedHospital?.name ?? "Select Hospital")
                                            .foregroundColor(viewModel.selectedHospital != nil ? .textPrimary : .textSecondary.opacity(0.5))
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(.textSecondary)
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: BRadius.md)
                                            .fill(Color.cardDark)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: BRadius.md)
                                                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                            )
                                    )
                                }
                            }

                            // Ward
                            formField(label: "Ward / Room", icon: "bed.double.fill") {
                                TextField("", text: $viewModel.newWard, prompt: Text("e.g. ICU, ER, Surgery Ward B").foregroundColor(.textSecondary.opacity(0.5)))
                                    .foregroundColor(.textPrimary)
                            }

                            // Units
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Units Needed")
                                    .font(BFont.captionBold())
                                    .foregroundColor(.textSecondary)

                                HStack(spacing: BSpacing.lg) {
                                    Button {
                                        if viewModel.newUnits > 1 {
                                            viewModel.newUnits -= 1
                                        }
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.system(size: 28))
                                            .foregroundColor(.textSecondary)
                                    }

                                    Text("\(viewModel.newUnits)")
                                        .font(BFont.metric(32))
                                        .foregroundColor(.textPrimary)
                                        .frame(width: 50)

                                    Button {
                                        if viewModel.newUnits < 10 {
                                            viewModel.newUnits += 1
                                        }
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 28))
                                            .foregroundColor(.bloodRed)
                                    }

                                    Spacer()

                                    Text("unit\(viewModel.newUnits > 1 ? "s" : "") of blood")
                                        .font(BFont.body())
                                        .foregroundColor(.textSecondary)
                                }
                            }

                            // Search Radius
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("Search Radius")
                                        .font(BFont.captionBold())
                                        .foregroundColor(.textSecondary)
                                    Spacer()
                                    Text("\(Int(viewModel.newRadius)) km")
                                        .font(BFont.captionBold())
                                        .foregroundColor(.bloodRed)
                                }

                                Slider(value: $viewModel.newRadius, in: 5...50, step: 5)
                                    .tint(.bloodRed)
                            }
                        }
                        .padding(.horizontal)

                        // Submit
                        Button {
                            viewModel.submitRequest()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                                isPresented = false
                            }
                        } label: {
                            HStack {
                                if viewModel.isSubmitting {
                                    ProgressView()
                                        .tint(.white)
                                    Text("Broadcasting to donors...")
                                } else {
                                    Image(systemName: "antenna.radiowaves.left.and.right")
                                    Text("Broadcast Request")
                                }
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(viewModel.newPatientName.isEmpty || viewModel.selectedHospital == nil)
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
    }

    // MARK: - Form Field Helper
    private func formField<Content: View>(label: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(BFont.captionBold())
                .foregroundColor(.textSecondary)

            HStack {
                Image(systemName: icon)
                    .foregroundColor(.textSecondary)
                content()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: BRadius.md)
                    .fill(Color.cardDark)
                    .overlay(
                        RoundedRectangle(cornerRadius: BRadius.md)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
            )
        }
    }
}

#Preview {
    NewRequestView(
        viewModel: RequesterViewModel(user: MockData.requesterAccount),
        isPresented: .constant(true)
    )
}
