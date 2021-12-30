import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../Constants/Spacing.dart';
import '../../Constants/Themes.dart';
import '../../Models/Instruction.dart';

class CookingModeCarousel extends StatefulWidget {
  final List<Instruction> items;
  final Function() toggle;
  final Function(Instruction) toggleDone;
  const CookingModeCarousel(
      {Key? key,
      required this.toggle,
      required this.items,
      required this.toggleDone})
      : super(key: key);

  @override
  State<CookingModeCarousel> createState() => _CookingModeCarouselState();
}

class _CookingModeCarouselState extends State<CookingModeCarousel>
    with SingleTickerProviderStateMixin {
  final CarouselController carouselController = CarouselController();
  late AnimationController _blurController;
  final Tween<double> _blurTweenX = Tween(begin: 0, end: 7);
  final Tween<double> _blurTweenY = Tween(begin: 0, end: -7);
  final Tween<double> _white = Tween(begin: 0, end: 0.03);

  late Animation<double> _blurX;
  late Animation<double> _blurY;
  late Animation<double> _whiteAnimation;

  @override
  void initState() {
    _blurController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _blurX = _blurTweenX.animate(_blurController);
    _blurY = _blurTweenY.animate(_blurController);
    _whiteAnimation = _white.animate(_blurController);

    _blurController.forward();
    _blurController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  _closeCookingMode() async {
    await _blurController.animateBack(0);
  }

  @override
  void dispose() {
    _blurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(_whiteAnimation.value),
      body: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _blurX.value, sigmaY: _blurY.value),
          child: Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(child: GestureDetector(onTap: () async {
                  await _closeCookingMode();
                  widget.toggle();
                })),
                SizeTransition(
                  sizeFactor: CurvedAnimation(
                      curve: Curves.fastOutSlowIn, parent: _blurController),
                  child: CarouselSlider(
                    carouselController: carouselController,
                    options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * .6,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        viewportFraction: .75),
                    items: widget.items
                        .map(
                          (e) => Builder(builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                carouselController
                                    .animateToPage(widget.items.indexOf(e));
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).backgroundColor,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).backgroundColor,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: const [
                                        BoxShadow(
                                            blurRadius: 15,
                                            spreadRadius: 3,
                                            color: Colors.black26)
                                      ]),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary
                                                  .withOpacity(0.1),
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary),
                                              borderRadius:
                                                  BorderRadius.circular(60 / 2),
                                            ),
                                            child: Center(
                                              child: Text(
                                                  (widget.items.indexOf(e) + 1)
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .tertiary,
                                                      fontSize: 21)),
                                            )),
                                      ),
                                      vRegularSpace,
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Text(
                                            e.description,
                                            style:
                                                const TextStyle(fontSize: 21),
                                          ),
                                        ),
                                      ),
                                      vRegularSpace,
                                      Align(
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onTap: () {
                                            widget.toggleDone(e);
                                            if (e.done &&
                                                e != widget.items.last) {
                                              carouselController.animateToPage(
                                                  widget.items.indexOf(e) + 1);
                                            }
                                          },
                                          child: Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                color: e.done
                                                    ? goodColor.withOpacity(.1)
                                                    : Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(0.1),
                                                border: Border.all(
                                                    color: e.done
                                                        ? goodColor
                                                        : Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(.5)),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        60 / 2),
                                              ),
                                              child: Center(
                                                  child: Icon(
                                                Icons.check,
                                                size: 30,
                                                color: e.done
                                                    ? goodColor
                                                    : Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(0.3),
                                              ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        )
                        .toList(),
                  ),
                ),
                Expanded(child: GestureDetector(onTap: () async {
                  await _closeCookingMode();
                  widget.toggle();
                })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
