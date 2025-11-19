import 'package:aayojan/core/network/endpoints.dart';
import 'package:aayojan/core/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_typo.dart';
import '../pages/manage_family_member_page.dart';

class FamilyCard extends StatelessWidget {
  final String name;
  final String relationName;
  final String imageUrl;
  // final String location;
  final Function onDelete;
  final Function onEdit;
  const FamilyCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.relationName,
    // required this.location,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: CustomColors.bgSecondary,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: CustomColors.ligthPrimary,
                child: imageUrl.isNotEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image:
                                NetworkImage("${Endpoints.imageUrl}$imageUrl"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : SvgPicture.asset(
                        'assets/icons/person.svg',
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          CustomColors.bgLight,
                          BlendMode.srcIn,
                        ),
                      ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Name
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.30,
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTypography.bodyLarge
                          .copyWith(color: CustomColors.bgLight),
                    ),
                  ),

                  // relation
                  Text(
                    relationName.toString(),
                    style: CustomTypography.bodyMedium
                        .copyWith(color: CustomColors.bgLight),
                  ),
                ],
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  onEdit();
                },
                child: SvgPicture.asset(
                  'assets/icons/edit.svg',
                  height: 18,
                  width: 18,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // delete family member
                  GestureDetector(
                    onTap: () {
                      onDelete();
                    },
                    child: const Icon(
                      Ionicons.trash_outline,
                      color: CustomColors.bgLight,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
