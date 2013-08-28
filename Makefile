# The default target rebuilds the .qm files that are older than their
# corresponding .ts source.
LANGUAGES := fr
QM_FILES := $(foreach lang,$(LANGUAGES),\
   flo_check_homework/translations/$(lang)/flo-check-homework.$(lang).qm)

all: $(QM_FILES)

define qm_rule
flo_check_homework/translations/$1/flo-check-homework.$1.qm: \
                                                flo-check-homework.$1.ts
	lrelease-qt4 '$$<' -qm '$$@'
endef

$(foreach lang,$(LANGUAGES),$(eval $(call qm_rule,$(lang))))

refreshts:
        # May be used with -noobsolete to remove obsolete strings
	pylupdate4 flo-check-homework.pro

refreshts_noobs:
	pylupdate4 -noobsolete flo-check-homework.pro

clean:
	rm -f $(QM_FILES)

.PHONY: all clean refreshts refreshts_noobs