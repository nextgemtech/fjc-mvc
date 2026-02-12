import { application } from "../controllers/application";
import CheckboxSelectAll from "@stimulus-components/checkbox-select-all";
import Dialog from "@stimulus-components/dialog";
import Dropdown from "@stimulus-components/dropdown";
import Notification from "@stimulus-components/notification";
import PasswordVisibility from "@stimulus-components/password-visibility";
import Popover from "@stimulus-components/popover";
import Sortable from "@stimulus-components/sortable";
import Timeago from "@stimulus-components/timeago";
import { registerControllers } from "stimulus-vite-helpers";

// controllers
const controllers = import.meta.glob("./**/*_controller.js", { eager: true });
registerControllers(application, controllers);

// Stimuslus controllers
application.register("checkbox-select-all", CheckboxSelectAll);
application.register("dialog", Dialog);
application.register("dropdown", Dropdown);
application.register("password-visibility", PasswordVisibility);
application.register("popover", Popover);
application.register("sortable", Sortable);
application.register("notification", Notification);
application.register("timeago", Timeago);
