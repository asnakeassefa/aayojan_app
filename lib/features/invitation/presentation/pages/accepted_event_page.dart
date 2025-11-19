import 'package:aayojan/core/theme/custom_typo.dart';
import 'package:aayojan/core/utility/date_formater.dart';
import 'package:aayojan/core/widgets/custom_button.dart';
import 'package:aayojan/features/invitation/presentation/bloc/invitation_cubit.dart';
import 'package:aayojan/features/invitation/presentation/bloc/invitation_state.dart';
import 'package:aayojan/features/manage_family/data/model/family_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/custom_colors.dart';

class AcceptedEventPage extends StatefulWidget {
  static const String routeName = '/accepted_event_page';
  final String title;
  final String time;
  final String venue;
  final String date;
  final String imgUrl;
  final String id;

  const AcceptedEventPage(
      {super.key,
      required this.title,
      required this.time,
      required this.venue,
      required this.date,
      required this.imgUrl,
      required this.id});

  @override
  State<AcceptedEventPage> createState() => _AcceptedEventPageState();
}

class _AcceptedEventPageState extends State<AcceptedEventPage> {
  List<String> familyList = [];
  List<MemberData> families = [];
  bool selectedAll = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<InvitationCubit>()..getFamilies(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title[0].toUpperCase() + widget.title.substring(1),
            ),
            centerTitle: true,
          ),
          body: BlocConsumer<InvitationCubit, InvitationState>(
            listener: (context, state) {
              if (state is InvitationAccepted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Invitation Accepted'),
                    backgroundColor: CustomColors.success,
                  ),
                );
                Navigator.pop(context,true);
              }

              if (state is FamilyLoaded) {
                // list family members
                for (FamilyData family in state.family.familyData ?? []) {
                  for (MemberData item in family.members?.memberData ?? []) {
                    families.add(item);
                  }
                }

                setState(() {
                  families = families;
                });
              }

              if (state is InvitationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: CustomColors.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is InvitationLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: CustomColors.bgLight,
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black.withOpacity(0.7),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            opacity: 0.5,
                            image: NetworkImage(
                              widget.imgUrl,
                            ),
                          ),
                        ),
                        height: MediaQuery.sizeOf(context).height * .2,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.time,
                              style: CustomTypography.titleXLarge.copyWith(
                                color: CustomColors.bgLight,
                              ),
                            ),
                            Text(
                              formatDate(widget.date),
                              style: CustomTypography.bodyLarge.copyWith(
                                color: CustomColors.bgLight,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Venue',
                              style: CustomTypography.titleMedium.copyWith(
                                  color: CustomColors.bgLight,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.venue,
                              style: CustomTypography.bodyLarge.copyWith(
                                color: CustomColors.bgLight,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Choose your Family Members',
                        style: CustomTypography.headLineLarge
                            .copyWith(color: CustomColors.bgLight),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            fillColor: WidgetStateProperty.all(
                                CustomColors.bgLight.withOpacity(0.2)),
                            value: selectedAll,
                            onChanged: (value) {
                              setState(() {
                                selectedAll = value!;
                                if (value) {
                                  familyList = families
                                      .map((e) => e.id.toString())
                                      .toList();
                                } else {
                                  familyList = [];
                                }
                              });
                            },
                            // activeColor: CustomColors.bgLight,
                            side: const BorderSide(
                              color: CustomColors.bgLight,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Select All',
                            style: CustomTypography.headLineSmall.copyWith(
                              color: CustomColors.bgLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.3,
                        child: ListView.builder(
                            itemCount: families.length,
                            itemBuilder: (context, index) {
                              return FamilySelectCard(
                                isChecked: familyList
                                    .contains(families[index].id.toString()),
                                name:
                                    "${families[index].firstName} ${families[index].lastName}",
                                onChange: (value) {
                                  setState(() {
                                    if (value!) {
                                      familyList.add(
                                        families[index].id.toString(),
                                      );
                                    } else {
                                      familyList.remove(
                                        families[index].id.toString(),
                                      );
                                    }
                                  });
                                },
                              );
                            }),
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        onPressed: () {
                          Map<String, dynamic> data = {
                            "invitation_id": widget.id,
                            "attend_member_count": familyList.length + 1,
                            "guest_response_preferences": ["Accept with thanks"]
                          };
                          context
                              .read<InvitationCubit>()
                              .acceptInvitation('id', data);
                        },
                        text: "Continue",
                        isLoading: false,
                        height: 54,
                        width: double.infinity,
                      )
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}

class FamilySelectCard extends StatelessWidget {
  final Function(bool?) onChange;
  final String name;
  final bool isChecked;
  const FamilySelectCard({
    super.key,
    required this.isChecked,
    required this.onChange,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // name
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: CustomColors.contentPrimary.withOpacity(0.5)),
          width: MediaQuery.sizeOf(context).width * 0.7,
          child: Text(
            name,
            style: CustomTypography.headLineSmall
                .copyWith(color: CustomColors.bgLight),
          ),
        ),
        // check box with border white

        Checkbox(
          fillColor:
              WidgetStateProperty.all(CustomColors.bgLight.withOpacity(0.2)),
          value: isChecked,
          onChanged: onChange,
          side: const BorderSide(
            color: CustomColors.bgLight,
          ),
        ),
      ],
    );
  }
}
